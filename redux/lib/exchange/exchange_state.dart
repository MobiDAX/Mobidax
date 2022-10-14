import 'dart:convert';

import 'package:graphql/internal.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:k_chart/entity/k_line_entity.dart';
import '../graphql_client.dart';

part 'exchange_state.g.dart';

@JsonSerializable(nullable: false)
class ExchangePageState {
  @JsonKey(ignore: true)
  final bool isLoading;
  @JsonKey(ignore: true)
  final Exception error;
  @JsonKey(ignore: true)
  final String sucess;
  final bool isOrderbook;
  final int selectedTabIndex;
  final int selectedPeriod;
  final List<KLineEntity> kLineState;
  final OrderbookState orderbookState;
  final List<TradeItem> marketTrades;
  final List<TradeItem> userTrades;
  final List<OrderItem> userOrders;

  static Stream<FetchResult> substream(String marketId, int period) =>
      GraphQLClientAPI.subStream('marketKLine', r'''
          subscription marketKLine($interval: Int, $market: String) {
            marketKLine(interval: $interval, market: $market){
              at,
              o,
              l,
              h,
              c,
              v
            }
          }
        ''', {
        'interval': period,
        'market': marketId,
      });

  static Stream<FetchResult> marketTradesStream(String marketId) =>
      GraphQLClientAPI.subStream('marketTrades', r'''
          subscription marketTrades($market: String) {
            marketTrades(market: $market){
              id,
              price,
              amount,
              total,
              side,
              created_at,
              taker_type
            }
          }
        ''', {
        'market': marketId,
      });

  static Stream<FetchResult> userTradesStream(
          String marketId, String barongSession) =>
      GraphQLClientAPI.subStream('userTrades', r'''
          subscription userTrades($market: String, $_barong_session: String) {
            userTrades(market: $market, _barong_session: $_barong_session){
              id,
              price,
              amount,
              total,
              created_at,
              side,
              taker_type
            }
          }
        ''', {
        'market': marketId,
        '_barong_session': barongSession,
      });

  static Stream<FetchResult> userOrdersStream(
          String marketId, String barongSession) =>
      GraphQLClientAPI.subStream('userOrders', r'''
          subscription userOrders($market: String, $_barong_session: String) {
            userOrders(market: $market, _barong_session: $_barong_session) {
              id,
              price,
              market,
              origin_volume,
              side,
              created_at,
              state
            }
          }
        ''', {
        'market': marketId,
        '_barong_session': barongSession,
      });

  ExchangePageState(
      {this.isLoading,
      this.error,
      this.sucess,
      this.isOrderbook,
      this.selectedPeriod,
      this.selectedTabIndex,
      this.kLineState,
      this.orderbookState,
      this.marketTrades,
      this.userOrders,
      this.userTrades});

  ExchangePageState copy({
    bool isLoading,
    Exception error,
    String sucess,
    int selectedPeriod,
    isOrderbook,
    selectedTabIndex,
    List<KLineEntity> kLineState,
    OrderbookState orderbookState,
    List<TradeItem> marketTrades,
    List<TradeItem> userTrades,
    List<OrderItem> userOrders,
  }) =>
      ExchangePageState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        sucess: sucess,
        selectedPeriod: selectedPeriod ?? this.selectedPeriod,
        isOrderbook: isOrderbook ?? this.isOrderbook,
        kLineState: kLineState ?? this.kLineState,
        selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
        orderbookState: orderbookState ?? this.orderbookState,
        marketTrades: marketTrades ?? this.marketTrades,
        userTrades: userTrades ?? this.userTrades,
        userOrders: userOrders ?? this.userOrders,
      );

  factory ExchangePageState.fromJson(Map<String, dynamic> json) =>
      _$ExchangePageStateFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangePageStateToJson(this);

  static ExchangePageState initialState() => ExchangePageState(
        isLoading: false,
        error: null,
        sucess: null,
        isOrderbook: false,
        selectedPeriod: 15,
        selectedTabIndex: 2,
        kLineState: [],
        orderbookState: OrderbookState.initialState(),
        marketTrades: [],
        userTrades: [],
        userOrders: [],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExchangePageState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          error == other.error &&
          sucess == other.sucess &&
          isOrderbook == other.isOrderbook &&
          selectedPeriod == other.selectedPeriod &&
          selectedTabIndex == other.selectedTabIndex &&
          kLineState == other.kLineState &&
          orderbookState == other.orderbookState &&
          marketTrades == other.marketTrades &&
          userTrades == other.userTrades &&
          userOrders == other.userOrders;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      sucess.hashCode ^
      error.hashCode ^
      isOrderbook.hashCode ^
      selectedPeriod.hashCode ^
      selectedTabIndex.hashCode ^
      kLineState.hashCode ^
      orderbookState.hashCode ^
      marketTrades.hashCode ^
      userTrades.hashCode ^
      userOrders.hashCode;
}

@JsonSerializable(nullable: false)
class OrderbookState {
  final List<AskBid> asks;
  final List<AskBid> bids;

  static Stream<FetchResult> substream(String marketId) =>
      GraphQLClientAPI.subStream('marketUpdate', r'''
          subscription marketUpdate($market: String) {
            marketUpdate(market: $market){
              asks {
                amount
                price
              },
              bids {
                amount
                price
              },
            }
          }
        ''', {
        'market': marketId,
      }).distinct();

  OrderbookState({this.asks, this.bids});

  OrderbookState copy({List<AskBid> asks, List<AskBid> bids}) =>
      OrderbookState(asks: asks ?? this.asks, bids: bids ?? this.bids);

  factory OrderbookState.fromJson(Map<String, dynamic> json) =>
      _$OrderbookStateFromJson(json);

  Map<String, dynamic> toJson() => _$OrderbookStateToJson(this);

  static OrderbookState initialState() => OrderbookState(asks: [], bids: []);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderbookState &&
          runtimeType == other.runtimeType &&
          asks == other.asks &&
          bids == other.bids;

  @override
  int get hashCode => asks.hashCode ^ bids.hashCode;
}

@JsonSerializable(nullable: false)
class AskBid {
  final double amount;
  final double price;

  AskBid({this.amount, this.price});

  AskBid copy({double amount, double price}) =>
      AskBid(amount: amount ?? this.amount, price: price ?? this.price);

  factory AskBid.fromJson(Map<String, dynamic> json) => _$AskBidFromJson(json);

  Map<String, dynamic> toJson() => _$AskBidToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AskBid &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          price == other.price;

  @override
  int get hashCode => price.hashCode ^ amount.hashCode;
}

@JsonSerializable(nullable: false)
class TradeItem {
  final String id;
  final double price;
  final double amount;
  @JsonKey(nullable: true)
  final double total;
  @JsonKey(
      name: 'created_at',
      fromJson: _createdAtFromJson,
      toJson: _createdAtToJson)
  final int createdAt;
  @JsonKey(name: 'taker_type')
  final String takerType;
  @JsonKey(nullable: true)
  final String marketName;
  final String side;

  TradeItem(
      {this.id,
      this.price,
      this.amount,
      this.total,
      this.createdAt,
      this.marketName,
      this.side,
      this.takerType});

  TradeItem copy(
          {int id,
          double price,
          double amount,
          double total,
          String marketName,
          BigInt createdAt,
          String side,
          String takerType}) =>
      TradeItem(
          id: id ?? this.id,
          price: price ?? this.price,
          amount: amount ?? this.amount,
          total: total ?? this.total,
          marketName: marketName ?? this.marketName,
          createdAt: createdAt ?? this.createdAt,
          side: side ?? this.side,
          takerType: takerType ?? this.takerType);

  factory TradeItem.fromJson(Map<String, dynamic> json) =>
      _$TradeItemFromJson(json);

  Map<String, dynamic> toJson() => _$TradeItemToJson(this);

  static TradeItem initialState() => TradeItem(
      id: '',
      price: 0.0,
      amount: 0.0,
      marketName: '',
      total: 0.0,
      side: '',
      createdAt: 0,
      takerType: '');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TradeItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          price == other.price &&
          amount == other.amount &&
          marketName == other.marketName &&
          total == other.total &&
          side == other.side &&
          createdAt == other.createdAt &&
          takerType == other.takerType;

  @override
  int get hashCode =>
      price.hashCode ^
      amount.hashCode ^
      id.hashCode ^
      total.hashCode ^
      marketName.hashCode ^
      createdAt.hashCode ^
      side.hashCode ^
      takerType.hashCode;
}

@JsonSerializable(nullable: false)
class OrderItem {
  final int id;
  final String price;
  @JsonKey(name: 'origin_volume')
  final String originVolume;
  final String side;
  final String state;
  @JsonKey(
      name: 'created_at',
      fromJson: _createdAtFromJson,
      toJson: _createdAtToJson)
  final int createdAt;
  @JsonKey(nullable: true)
  final String marketName;
  final String market;
  OrderItem(
      {this.id,
      this.price,
      this.originVolume,
      this.side,
      this.createdAt,
      this.marketName,
      this.market,
      this.state});

  OrderItem copy(
          {int id,
          String price,
          String originVolume,
          String side,
          String state,
          String marketName,
          String market,
          int createdAt}) =>
      OrderItem(
          id: id ?? this.id,
          price: price ?? this.price,
          state: state ?? this.state,
          createdAt: createdAt ?? this.createdAt,
          marketName: marketName ?? this.marketName,
          market: market ?? this.market,
          originVolume: originVolume ?? this.originVolume,
          side: side ?? this.side);

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  static OrderItem initialState() => OrderItem(
      id: 0,
      price: '',
      originVolume: '',
      side: '',
      state: '',
      createdAt: 0,
      marketName: '',
      market: '');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          price == other.price &&
          createdAt == other.createdAt &&
          marketName == other.marketName &&
          state == other.state &&
          originVolume == other.originVolume &&
          market == other.market &&
          side == other.side;

  @override
  int get hashCode =>
      price.hashCode ^
      id.hashCode ^
      originVolume.hashCode ^
      createdAt.hashCode ^
      marketName.hashCode ^
      state.hashCode ^
      market.hashCode ^
      side.hashCode;
}

int _createdAtFromJson(String json) => int.tryParse(json);
String _createdAtToJson(int createdAt) => jsonEncode(createdAt);
