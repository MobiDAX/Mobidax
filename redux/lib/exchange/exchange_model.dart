import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:graphql/client.dart';
import 'package:k_chart/entity/k_line_entity.dart';
import 'package:mobidax_redux/account/account_state.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';
import '../exchange/exchange_actions.dart';
import '../exchange/exchange_state.dart';
import '../markets/markets_state.dart';
import '../store.dart';

class ExchangePageModel extends BaseModel<AppState> {
  final MarketItemState selectedMarket;
  final bool isLoading;
  final OperationException error;
  final String sucess;
  final bool isOrderbook;
  final bool isAuthourized;
  final int selectedPeriod;
  final int selectedTabIndex;
  final List<KLineEntity> klineState;
  final List<TradeItem> marketTrades;
  final List<TradeItem> userTrades;
  final List<OrderItem> userOrders;
  final OrderbookState orderbook;
  final List<UserBalanceItemState> balances;
  final UserSessionState userSession;
  int id;

  ExchangePageModel(
      {this.selectedMarket,
      this.isLoading,
      this.error,
      this.sucess,
      this.isOrderbook,
      this.isAuthourized,
      this.selectedTabIndex,
      this.id,
      this.selectedPeriod,
      this.klineState,
      this.marketTrades,
      this.userTrades,
      this.userOrders,
      this.orderbook,
      this.balances,
      this.userSession});

  VoidCallback onMarketSelector;
  Function(String market) cancelAllOrders;
  Function clearError;
  Function(bool selected) onSwitchSelect;
  Function(String barongSession, String market, orderSide side, orderType type,
      double amount,
      [double price]) onPlaceOrder;
  VoidCallback onOrderSelect;
  Function(int id) onTabSelect;
  Function onFetchBalance;
  Function(int period, String selectedMarketId) onFetchMore;
  Function(int id, String selectedMarketName) onPeriodSelect;
  Function(String barongSession, int orderId) onCancelOrder;

  ExchangePageModel.build(
      {@required this.onMarketSelector,
      this.selectedMarket,
      this.onPlaceOrder,
      this.isLoading,
      this.error,
      this.sucess,
      this.isOrderbook,
      this.isAuthourized,
      this.selectedPeriod,
      this.selectedTabIndex,
      this.onSwitchSelect,
      this.cancelAllOrders,
      this.onTabSelect,
      this.onFetchMore,
      this.onPeriodSelect,
      this.onCancelOrder,
      this.onFetchBalance,
      this.clearError,
      this.klineState,
      this.onOrderSelect,
      this.marketTrades,
      this.userTrades,
      this.userOrders,
      this.orderbook,
      this.balances,
      this.userSession})
      : super(equals: [
          isLoading,
          error,
          sucess,
          selectedPeriod,
          selectedMarket,
          isAuthourized,
          selectedTabIndex,
          isOrderbook,
          klineState,
          marketTrades,
          userTrades,
          userOrders,
          userSession,
          orderbook,
          balances
        ]);

  @override
  ExchangePageModel fromStore() => ExchangePageModel.build(
      onMarketSelector: () {
        dispatch(NavigateAction.pushNamed("/selectMarket"));
      },
      onSwitchSelect: (bool selected) {
        dispatch(PressSwitchAction(selected: selected));
      },
      onPlaceOrder: (String barongSession, String market, orderSide side,
          orderType type, double amount, [double price]) {
        dispatch(CreateOrderAction(
            barongSession: barongSession,
            market: market,
            side: side,
            type: type,
            amount: amount,
            price: price));
      },
      onPeriodSelect: (int period, String selectedMarketName) {
        dispatch(SelectPeriodAction(
            period: period, selectedMarketName: selectedMarketName));
      },
      onTabSelect: (int id) {
        dispatch(PressTabAction(id: id));
      },
      onOrderSelect: () {
        dispatch(NavigateAction.pushNamed("/orderPlacementPage"));
      },
      onCancelOrder: (String barongSession, int id) {
        dispatch(CancelOrderAction(id: id));
      },
      clearError: () {
        dispatch(ClearStatusAction());
      },
      onFetchMore: (int period, String selectedMarketId) {
        dispatch(KlineFetchAction(
            period: period, selectedMarketId: selectedMarketId));
      },
      cancelAllOrders: (String market) {
        dispatch(CancelAllOrdersAction(market: market));
      },
      onFetchBalance: () {
        dispatch(FetchBalance());
      },
      selectedMarket: state.marketsPageState.marketItems.isNotEmpty
          ? state.marketsPageState.marketItems.firstWhere(
              (element) => element.selected,
              orElse: () => MarketItemState.initialState())
          : MarketItemState.initialState(),
      isLoading: state.exchangePageState.isLoading,
      selectedPeriod: state.exchangePageState.selectedPeriod,
      error: state.exchangePageState.error,
      sucess: state.exchangePageState.sucess,
      isOrderbook: state.exchangePageState.isOrderbook,
      isAuthourized: state.accountUserState.isAuthourized,
      selectedTabIndex: state.exchangePageState.selectedTabIndex,
      klineState: state.exchangePageState.kLineState,
      marketTrades: state.exchangePageState.marketTrades,
      userTrades: state.exchangePageState.userTrades,
      userOrders: state.exchangePageState.userOrders,
      balances: state.accountUserState.balances,
      orderbook: state.exchangePageState.orderbookState,
      userSession: state.accountUserState.userSession);
}
