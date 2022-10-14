import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/internal.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:k_chart/entity/k_line_entity.dart';
import 'package:mobidax_redux/account/account_actions.dart';
import 'package:mobidax_redux/funds/funds_actions.dart';
import 'package:mobidax_redux/helper/validate_session.dart';
import 'package:mobidax_redux/types.dart';
import '../exchange/exchange_state.dart';
import '../markets/markets_state.dart';
import '../store.dart';
import '../graphql_client.dart';

class SelectMarketAction extends ReduxAction<AppState> {
  final String marketID;
  final bool fromNav;

  SelectMarketAction({@required this.marketID, @required this.fromNav});

  @override
  Future<AppState> reduce() async {
    if (state.marketsPageState.marketItems
            .firstWhere((element) => element.selected == true)
            .id ==
        marketID) {
      return null;
    } else {
      var markets = state.marketsPageState.copy().marketItems;
      List<MarketItemState> result = [];
      markets.forEach((element) {
        if (element.id == marketID) {
          result.add(element.copy(selected: true));
        } else {
          result.add(element.copy(selected: false));
        }
      });
      await afterSelected();
      return state.copy(
          marketsPageState: state.marketsPageState.copy(
        marketItems: result,
      ));
    }
  }

  afterSelected() async {
    await dispatchFuture(CancelSubsAction());
    await dispatchFuture(ClearExStateAction(states: {
      "kLineState": <KLineEntity>[],
      "marketTrades": <TradeItem>[],
      "userTrades": <TradeItem>[],
      "orderbookState": true
    }));
    dispatch(KlineFetchAction(
        selectedMarketId: marketID,
        period: state.exchangePageState.selectedPeriod));
    dispatch(KlineSubAction(
        selectedMarketId: marketID,
        period: state.exchangePageState.selectedPeriod));
    dispatch(OrderbookFetchAction(selectedMarketId: marketID));
    dispatch(MarketUpdateSubAction(selectedMarketId: marketID));
    dispatch(MarketTradeFetchAction(selectedMarketId: marketID));
    dispatch(MarketTradeSubAction(selectedMarketId: marketID));
    if (state.accountUserState.isAuthourized) {
      dispatch(UserTradeFetchAction(
          selectedMarketId: marketID,
          barongSession: state.accountUserState.userSession.barongSession));
      dispatch(UserOrdersFetchAction(
          selectedMarketId: marketID,
          barongSession: state.accountUserState.userSession.barongSession));
      dispatch(UserTradeSubAction(
          selectedMarketId: marketID,
          barongSession: state.accountUserState.userSession.barongSession));
      dispatch(UserOrderSubAction(
          selectedMarketId: marketID,
          barongSession: state.accountUserState.userSession.barongSession));
    }
  }

  @override
  void after() {
    if (!fromNav) dispatch(NavigateAction.pop());
    super.after();
  }
}

class PressSwitchAction extends ReduxAction<AppState> {
  final bool selected;

  PressSwitchAction({this.selected});

  @override
  AppState reduce() {
    return state.copy(
        exchangePageState: state.exchangePageState.copy(isOrderbook: selected));
  }
}

class PressTabAction extends ReduxAction<AppState> {
  final int id;

  PressTabAction({this.id});

  @override
  Future<AppState> reduce() async {
    return state.copy(
        exchangePageState: state.exchangePageState.copy(selectedTabIndex: id));
  }
}

class KlineSubAction extends ReduxAction<AppState> {
  final String selectedMarketId;
  final int period;

  KlineSubAction({this.selectedMarketId, this.period = 15});

  @override
  AppState reduce() {
    if (!GetIt.I.isRegistered(instanceName: 'KLineSub')) {
      GetIt.I.registerSingleton(
          ExchangePageState.substream(selectedMarketId, period).listen(
              (final FetchResult message) {
            if (message.errors != null && message.errors.isNotEmpty) {
              dispatch(PushStatusAction(
                  error: Exception("Unable to subscribe to k-line updates")));
            }

            var k = message.data['marketKLine'][0];
            if (state.exchangePageState.kLineState.isNotEmpty)
              dispatch(KlineUpdateAction(
                  entity: KLineEntity.fromCustom(
                time: k['at'] * 1000,
                open: k['o'].toDouble(),
                close: k['c'].toDouble(),
                high: k['h'].toDouble(),
                low: k['l'].toDouble(),
                vol: k['v'].toDouble(),
                amount: k['v'].toDouble(),
                ratio: 0.0,
                change: 0.0,
              )));
          }, onError: (Object error) {
            print((error is SubscriptionError) ? error.payload : error);
          }, onDone: () {
            print("ws communication is done");
          }),
          instanceName: 'KLineSub');
    }
    return null;
  }
}

class KlineFetchAction extends ReduxAction<AppState> {
  final String selectedMarketId;
  final int period;

  KlineFetchAction({this.selectedMarketId, this.period = 15});

  static const KlineFetchQuery = r'''
          query kLine($market: String!, $period: Int!, $time_from: Int, $time_to: Int) {
            kLine(market: $market, period: $period, time_from: $time_from, time_to: $time_to){
              at,
              o,
              l,
              h,
              c,
              v
            }
          }
        ''';

  @override
  void before() {
    if (state.exchangePageState.kLineState.isEmpty)
      dispatch(DataLoadingAction(isLoading: true));
    super.before();
  }

  @override
  void after() {
    dispatch(DataLoadingAction(isLoading: false));
    super.after();
  }

  @override
  Future<AppState> reduce() async {
    var _timeFrom = state.exchangePageState.kLineState.isEmpty
        ? (DateTime.now().millisecondsSinceEpoch / 1000).round() - 2629743
        : (state.exchangePageState.kLineState.first.time / 1000 - 2629743)
            .round();
    var _timeTo = state.exchangePageState.kLineState.isEmpty
        ? (DateTime.now().millisecondsSinceEpoch / 1000).round()
        : (state.exchangePageState.kLineState.first.time / 1000).round();

    final QueryOptions options = QueryOptions(
      documentNode: gql(KlineFetchQuery),
      variables: <String, dynamic>{
        'market': selectedMarketId,
        'period': period,
        "time_from": _timeFrom,
        'time_to': _timeTo
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          exchangePageState:
              state.exchangePageState.copy(error: result.exception));
    } else {
      List<KLineEntity> inState = List.from(state.exchangePageState.kLineState);
      List<KLineEntity> fetched = [];
      result.data['kLine'].forEach((k) {
        fetched.add(KLineEntity.fromCustom(
          time: k['at'] * 1000,
          open: k['o'].toDouble(),
          close: k['c'].toDouble(),
          high: k['h'].toDouble(),
          low: k['l'].toDouble(),
          vol: k['v'].toDouble(),
          amount: k['v'].toDouble(),
          ratio: 0.0,
          change: 0.0,
        ));
      });

      var time = Set<int>();
      List<KLineEntity> res = [];

      for (var i in (fetched + inState)) {
        if (time.add(i.time)) {
          res.add(i);
        }
      }

      return state.copy(
          exchangePageState: state.exchangePageState.copy(
        kLineState: res,
      ));
    }
  }
}

class KlineUpdateAction extends ReduxAction<AppState> {
  final KLineEntity entity;

  KlineUpdateAction({this.entity});

  @override
  AppState reduce() {
    List<KLineEntity> res =
        List<KLineEntity>.from(state.exchangePageState.kLineState);

    res.removeWhere((element) => element.time == entity.time);

    res.add(entity);

    return state.copy(
        exchangePageState: state.exchangePageState.copy(
      kLineState: res,
    ));
  }
}

class MarketUpdateSubAction extends ReduxAction<AppState> {
  final String selectedMarketId;

  MarketUpdateSubAction({this.selectedMarketId});

  @override
  AppState reduce() {
    if (!GetIt.I.isRegistered(instanceName: 'MarketUpdateSub')) {
      GetIt.I.registerSingleton(
          OrderbookState.substream(selectedMarketId).listen(
              (final FetchResult message) {
            if (message.errors != null && message.errors.isNotEmpty)
              dispatch(PushStatusAction(
                  error:
                      Exception("Unable to subscribe to orderbook updates")));
            dispatch(MarketUpdateAction(
                orderbook:
                    OrderbookState.fromJson(message.data['marketUpdate'])));
          }, onError: (Object error) {
            print((error is SubscriptionError) ? error.payload : error);
          }, onDone: () {
            print("ws communication is done");
          }),
          instanceName: 'MarketUpdateSub');
    }
    return null;
  }
}

class MarketUpdateAction extends ReduxAction<AppState> {
  final OrderbookState orderbook;

  MarketUpdateAction({this.orderbook});

  @override
  AppState reduce() {
    return state.copy(
      exchangePageState:
          state.exchangePageState.copy(orderbookState: orderbook),
    );
  }
}

class MarketTradeFetchAction extends ReduxAction<AppState> {
  final String selectedMarketId;

  MarketTradeFetchAction({this.selectedMarketId});

  static const MarketTradeFetchQuery = r'''
          query trades($market: String!) {
            trades(market: $market){
              id,
              price,
              amount,
              total,
              created_at,
              side,
              taker_type
            }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(MarketTradeFetchQuery),
      variables: <String, dynamic>{
        'market': selectedMarketId,
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          exchangePageState:
              state.exchangePageState.copy(error: result.exception));
    } else {
      List<TradeItem> res = [];

      result.data['trades'].forEach((k) {
        res.add(TradeItem.fromJson(k));
      });

      return state.copy(
          exchangePageState: state.exchangePageState.copy(
        marketTrades: res,
      ));
    }
  }
}

class MarketTradeSubAction extends ReduxAction<AppState> {
  final String selectedMarketId;

  MarketTradeSubAction({this.selectedMarketId});

  @override
  AppState reduce() {
    if (!GetIt.I.isRegistered(instanceName: 'MarketTradeSub')) {
      GetIt.I.registerSingleton(
          ExchangePageState.marketTradesStream(selectedMarketId).listen(
              (final FetchResult message) {
            if (message.errors != null && message.errors.isNotEmpty)
              dispatch(PushStatusAction(
                  error: Exception(
                      "Unable to subscribe to market trades updates")));
            var t = message.data['marketTrades'][0];
            dispatch(MarketTradeUpdateAction(trade: TradeItem.fromJson(t)));
          }, onError: (Object error) {
            print((error is SubscriptionError) ? error.payload : error);
          }, onDone: () {
            print("ws communication is done");
          }),
          instanceName: 'MarketTradeSub');
    }
    return null;
  }
}

class MarketTradeUpdateAction extends ReduxAction<AppState> {
  final TradeItem trade;

  MarketTradeUpdateAction({this.trade});

  @override
  AppState reduce() {
    List<TradeItem> res =
        List<TradeItem>.from(state.exchangePageState.marketTrades);

    if (!res.contains(trade)) {
      res.insert(0, trade);
    }

    return state.copy(
        exchangePageState: state.exchangePageState.copy(
      marketTrades: res,
    ));
  }
}

class UserTradeFetchAction extends ReduxAction<AppState> {
  final String selectedMarketId;
  final String barongSession;

  UserTradeFetchAction({this.selectedMarketId, this.barongSession});

  static const UserTradeFetchQuery = r'''
          query userTrades($market: String!, $_barong_session: String!) {
            userTrades(market: $market, _barong_session: $_barong_session){
              id,
              price,
              amount,
              total,
              side,
              created_at,
              taker_type,
              fee_amount,
            }
          }
        ''';

  @override
  void before() {
    dispatch(DataLoadingAction(isLoading: true));
    super.after();
  }

  @override
  void after() {
    dispatch(DataLoadingAction(isLoading: false));
    super.after();
  }

  @override
  Future<AppState> reduce() async {
    if (validateSession(
        state.accountUserState.userSession.barongSessionExpires)) {
      dispatch(DestroySessionAction());
      return null;
    } else {
      final QueryOptions options = QueryOptions(
        documentNode: gql(UserTradeFetchQuery),
        variables: <String, dynamic>{
          'market': selectedMarketId,
          '_barong_session': barongSession,
        },
      );

      final QueryResult result = await GraphQLClientAPI.client().query(options);

      if (result.hasException) {
        if (sessionInvalidException(result.exception))
          dispatch(DestroySessionAction());
        return state.copy(
            exchangePageState:
                state.exchangePageState.copy(error: result.exception));
      } else {
        List<TradeItem> res = state.exchangePageState.userTrades ?? [];

        result.data['userTrades'].forEach((k) {
          res.add(TradeItem.fromJson(k));
        });

        return state.copy(
            exchangePageState: state.exchangePageState.copy(
          userTrades: res,
        ));
      }
    }
  }
}

class UserTradeSubAction extends ReduxAction<AppState> {
  final String selectedMarketId;
  final String barongSession;

  UserTradeSubAction({this.selectedMarketId, this.barongSession});

  @override
  AppState reduce() {
    ExchangePageState.userTradesStream(selectedMarketId, barongSession).listen(
        (final FetchResult message) {
      if (message.errors != null && message.errors.isNotEmpty) {
        dispatch(PushStatusAction(
            error: Exception("Unable to subscribe to user trades updates")));
      } else {
        var t = message.data['userTrades'][0];
        dispatch(UserTradeUpdateAction(trade: TradeItem.fromJson(t)));
      }
    }, onError: (Object error) {
      print((error is SubscriptionError) ? error.payload : error);
    }, onDone: () {
      print("ws communication is done");
    });
    return null;
  }
}

class UserTradeUpdateAction extends ReduxAction<AppState> {
  final TradeItem trade;

  UserTradeUpdateAction({this.trade});

  @override
  AppState reduce() {
    List<TradeItem> res =
        List<TradeItem>.from(state.exchangePageState.userTrades);

    if (!res.contains(trade)) {
      res.insert(0, trade);
    }

    return state.copy(
        exchangePageState: state.exchangePageState.copy(
      userTrades: res,
    ));
  }
}

class UserOrdersFetchAction extends ReduxAction<AppState> {
  final String selectedMarketId;
  final String barongSession;

  UserOrdersFetchAction({this.selectedMarketId, this.barongSession});

  static const UserOrdersFetchQuery = r'''
          query userOrders($market: String!, $_barong_session: String!, $state: String) {
            userOrders(market: $market, _barong_session: $_barong_session, state: $state){
              id,
              price,
              market,
              origin_volume,
              state,
              created_at,
              side,
            }
          }
        ''';

  @override
  void before() {
    dispatch(DataLoadingAction(isLoading: true));
    super.before();
  }

  @override
  void after() {
    dispatch(DataLoadingAction(isLoading: false));
    super.before();
  }

  @override
  Future<AppState> reduce() async {
    if (validateSession(
        state.accountUserState.userSession.barongSessionExpires)) {
      if (state.accountUserState.userSession.barongSessionExpires != '')
        dispatch(DestroySessionAction());
      return null;
    } else {
      final QueryOptions options = QueryOptions(
        documentNode: gql(UserOrdersFetchQuery),
        variables: <String, dynamic>{
          'market': selectedMarketId,
          '_barong_session': barongSession,
          'state': "wait",
        },
      );

      final QueryResult result = await GraphQLClientAPI.client().query(options);

      if (result.hasException) {
        if (result.exception.toString().contains('authz.invalid_session'))
          dispatch(DestroySessionAction());
        return state.copy(
            exchangePageState:
                state.exchangePageState.copy(error: result.exception));
      } else {
        List<OrderItem> res = [];

        result.data['userOrders'].forEach((k) {
          res.add(OrderItem.fromJson(k));
        });

        return state.copy(
            exchangePageState: state.exchangePageState.copy(
          userOrders: res,
        ));
      }
    }
  }
}

class UserOrderSubAction extends ReduxAction<AppState> {
  final String selectedMarketId;
  final String barongSession;

  UserOrderSubAction({this.selectedMarketId, this.barongSession});

  @override
  AppState reduce() {
    ExchangePageState.userOrdersStream(selectedMarketId, barongSession).listen(
        (final FetchResult message) {
      if (message.errors != null && message.errors.isNotEmpty) {
        dispatch(PushStatusAction(
            error: Exception("Unable to subscribe to user orders updates")));
      } else {
        var t = message.data['userOrders'][0];
        dispatch(UserOrderUpdateAction(order: t));
      }
    }, onError: (Object error) {
      print((error is SubscriptionError) ? error.payload : error);
    }, onDone: () {
      print("ws communication is done");
    });
    return null;
  }
}

class UserOrderUpdateAction extends ReduxAction<AppState> {
  final Map order;

  UserOrderUpdateAction({this.order});

  @override
  AppState reduce() {
    List<OrderItem> res =
        List<OrderItem>.from(state.exchangePageState.userOrders);

    switch (order['state']) {
      case 'wait':
        {
          res.firstWhere(
              (element) => element.id == OrderItem.fromJson(order).id,
              orElse: () {
            res.insert(0, OrderItem.fromJson(order));
            return null;
          });
          break;
        }

      case 'cancel':
        {
          res.removeWhere((element) => element.id == order['id']);
          break;
        }

      case 'done':
        {
          res.removeWhere((element) => element.id == order['id']);
          break;
        }
    }

    return state.copy(
        exchangePageState: state.exchangePageState.copy(
      userOrders: res,
    ));
  }
}

class CancelSubsAction extends ReduxAction<AppState> {
  final List<String> subs;

  CancelSubsAction(
      {this.subs = const ['KLineSub', 'MarketTradeSub', 'MarketUpdateSub']});

  @override
  Future<AppState> reduce() async {
    subs.forEach((element) async {
      if (GetIt.I.isRegistered(instanceName: element)) {
        await GetIt.I.get(instanceName: element).cancel();
        GetIt.I.unregister(instanceName: element);
      }
    });

    return null;
  }
}

class ClearExStateAction extends ReduxAction<AppState> {
  final Map<String, dynamic> states;

  ClearExStateAction(
      {this.states = const {
        "kLineState": <KLineEntity>[],
        "marketTrades": <TradeItem>[],
        "userTrades": <TradeItem>[],
        "orderbookState": true
      }});

  @override
  Future<AppState> reduce() async {
    return state.copy(
        exchangePageState: state.exchangePageState.copy(
      kLineState: states.containsKey("kLineState")
          ? states["kLineState"]
          : List.from(state.exchangePageState.kLineState),
      marketTrades: states.containsKey("marketTrades")
          ? states["marketTrades"]
          : List.from(state.exchangePageState.marketTrades),
      userTrades: states.containsKey("userTrades")
          ? states["userTrades"]
          : List.from(state.exchangePageState.userTrades),
      orderbookState: states.containsKey("orderbookState")
          ? OrderbookState.initialState()
          : state.exchangePageState.orderbookState.copy(),
    ));
  }
}

class PushStatusAction extends ReduxAction<AppState> {
  final Exception error;
  final String success;

  PushStatusAction({this.error, this.success});

  @override
  AppState reduce() {
    return state.copy(
        exchangePageState:
            state.exchangePageState.copy(error: error, sucess: success));
  }
}

class ClearStatusAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return state.copy(
        exchangePageState:
            state.exchangePageState.copy(error: null, sucess: null));
  }
}

class DataLoadingAction extends ReduxAction<AppState> {
  final bool isLoading;

  DataLoadingAction({this.isLoading});

  @override
  AppState reduce() {
    return state.copy(
        exchangePageState: state.exchangePageState.copy(isLoading: isLoading));
  }
}

class CreateOrderAction extends ReduxAction<AppState> {
  final String barongSession;
  final String market;
  final orderSide side;
  final orderType type;
  final double price;
  final double amount;

  CreateOrderAction(
      {this.barongSession,
      this.market,
      this.side,
      this.type,
      this.price = 188.1,
      this.amount});

  @override
  void after() {
    // TODO: implement after
    dispatch(FetchTradeHistoryAction());
    dispatch(OrdersHistoryFetchAction());
    dispatch(FetchBalance());
    super.after();
  }

  static const createOrderMutation = r'''
                mutation createOrder($_barong_session:String!, $market: String!,$volume: Float!, $side: String!, $ord_type: String!, $price: Float) {
                  createOrder(_barong_session: $_barong_session, market: $market,side: $side, ord_type: $ord_type, price: $price, volume: $volume) {
                    id
                    price
                    market
                    state
                    kind
                    side
                    origin_volume
                   }
                }
        ''';

  @override
  Future<AppState> reduce() async {
    if (validateSession(
        state.accountUserState.userSession.barongSessionExpires)) {
      if (state.accountUserState.userSession.barongSessionExpires != '')
        dispatch(DestroySessionAction());
    } else {
      final QueryOptions options = QueryOptions(
        documentNode: gql(createOrderMutation),
        variables: <String, dynamic>{
          '_barong_session': barongSession,
          'market': market,
          'volume': amount,
          'side': describeEnum(side),
          'ord_type': describeEnum(type),
        },
      );

      if (type == orderType.limit) options.variables['price'] = price;

      final QueryResult result = await GraphQLClientAPI.client().query(options);
      if (result.hasException) {
        if (result.exception.toString().contains('authz.invalid_session'))
          dispatch(DestroySessionAction());
        return state.copy(
            exchangePageState:
                state.exchangePageState.copy(error: result.exception));
      } else {
        dispatch(PushStatusAction(success: tr('success.order.created')));
        return null;
      }
    }
    return null;
  }
}

class CancelOrderAction extends ReduxAction<AppState> {
  final int id;

  CancelOrderAction({this.id});

  static const cancelOrderMutation = r'''
                mutation cancelOrder($_barong_session:String!, $order_id: Int!) {
                  cancelOrder(_barong_session: $_barong_session, order_id: $order_id) {
                    id
                    market
                    state
                    kind
                    side
                    origin_volume
                    price
                   }
                }
        ''';

  @override
  Future<AppState> reduce() async {
    if (validateSession(
        state.accountUserState.userSession.barongSessionExpires)) {
      if (state.accountUserState.userSession.barongSessionExpires != '')
        dispatch(DestroySessionAction());
    } else {
      final QueryOptions options = QueryOptions(
        documentNode: gql(cancelOrderMutation),
        variables: <String, dynamic>{
          '_barong_session': state.accountUserState.userSession.barongSession,
          'order_id': id,
        },
      );

      final QueryResult result = await GraphQLClientAPI.client().query(options);
      if (result.hasException) {
        if (result.exception.toString().contains('authz.invalid_session'))
          dispatch(DestroySessionAction());
        return state.copy(
            exchangePageState:
                state.exchangePageState.copy(error: result.exception));
      } else {
        // No need to update order here, since websocket sends updates regarding the order!
//        dispatch(UserOrderUpdateAction(order: result.data['cancelOrder']));
        dispatch(PushStatusAction(success: tr('success.order.canceled')));
        return null;
      }
    }
    return null;
  }
}

class CancelAllOrdersAction extends ReduxAction<AppState> {
  CancelAllOrdersAction({this.market});

  final String market;

  static const cancelAllOrders = r'''
                mutation cancelAllOrders($_barong_session:String!, $market: String) {
                  cancelAllOrders(_barong_session: $_barong_session, market: $market) {
                    id
                    market
                    state
                    kind
                    side
                   }
                }
        ''';

  @override
  Future<AppState> reduce() async {
    if (validateSession(
        state.accountUserState.userSession.barongSessionExpires)) {
      if (state.accountUserState.userSession.barongSessionExpires != '')
        dispatch(DestroySessionAction());
    } else {
      final QueryOptions options = QueryOptions(
        documentNode: gql(cancelAllOrders),
        variables: <String, dynamic>{
          '_barong_session': state.accountUserState.userSession.barongSession,
          'market': market,
        },
      );

      final QueryResult result = await GraphQLClientAPI.client().query(options);
      if (result.hasException) {
        if (result.exception.toString().contains('authz.invalid_session'))
          dispatch(DestroySessionAction());
        return state.copy(
            exchangePageState:
                state.exchangePageState.copy(error: result.exception));
      } else {
        dispatch(PushStatusAction(success: tr('success.orders.canceled')));
        return null;
      }
    }
    return null;
  }
}

class SelectPeriodAction extends ReduxAction<AppState> {
  final int period;
  final String selectedMarketName;

  SelectPeriodAction({this.period, this.selectedMarketName});

  @override
  void before() async {
    dispatch(DataLoadingAction(isLoading: true));
    await dispatchFuture(CancelSubsAction(subs: ['KLineSub']));
    await dispatchFuture(
        ClearExStateAction(states: {"kLineState": <KLineEntity>[]}));
    super.before();
  }

  @override
  AppState reduce() {
    return state.copy(
        exchangePageState:
            state.exchangePageState.copy(selectedPeriod: period));
  }

  @override
  void after() {
    // TODO: implement after
    dispatch(
        KlineFetchAction(selectedMarketId: selectedMarketName, period: period));
    dispatch(
        KlineSubAction(selectedMarketId: selectedMarketName, period: period));
    super.after();
  }
}

class OrderbookFetchAction extends ReduxAction<AppState> {
  final String selectedMarketId;

  OrderbookFetchAction({this.selectedMarketId});

  static const MarketTradeFetchQuery = r'''
          query depth($market: String!) {
            depth(market: $market){
              asks{
                amount
                price
              }
              bids{
                amount
                price
              }
            }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(MarketTradeFetchQuery),
      variables: <String, dynamic>{
        'market': selectedMarketId,
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          exchangePageState:
              state.exchangePageState.copy(error: result.exception));
    } else {
      dispatch(MarketUpdateAction(
          orderbook: OrderbookState.fromJson(result.data['depth'])));

      return null;
    }
  }
}
