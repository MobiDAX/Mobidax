// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangePageState _$ExchangePageStateFromJson(Map<String, dynamic> json) {
  return ExchangePageState(
    isOrderbook: json['isOrderbook'] as bool,
    selectedPeriod: json['selectedPeriod'] as int,
    selectedTabIndex: json['selectedTabIndex'] as int,
    kLineState: (json['kLineState'] as List)
        .map((e) => KLineEntity.fromJson(e as Map<String, dynamic>))
        .toList(),
    orderbookState:
        OrderbookState.fromJson(json['orderbookState'] as Map<String, dynamic>),
    marketTrades: (json['marketTrades'] as List)
        .map((e) => TradeItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    userOrders: (json['userOrders'] as List)
        .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    userTrades: (json['userTrades'] as List)
        .map((e) => TradeItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ExchangePageStateToJson(ExchangePageState instance) =>
    <String, dynamic>{
      'isOrderbook': instance.isOrderbook,
      'selectedTabIndex': instance.selectedTabIndex,
      'selectedPeriod': instance.selectedPeriod,
      'kLineState': instance.kLineState,
      'orderbookState': instance.orderbookState,
      'marketTrades': instance.marketTrades,
      'userTrades': instance.userTrades,
      'userOrders': instance.userOrders,
    };

OrderbookState _$OrderbookStateFromJson(Map<String, dynamic> json) {
  return OrderbookState(
    asks: (json['asks'] as List)
        .map((e) => AskBid.fromJson(e as Map<String, dynamic>))
        .toList(),
    bids: (json['bids'] as List)
        .map((e) => AskBid.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$OrderbookStateToJson(OrderbookState instance) =>
    <String, dynamic>{
      'asks': instance.asks,
      'bids': instance.bids,
    };

AskBid _$AskBidFromJson(Map<String, dynamic> json) {
  return AskBid(
    amount: json['amount'] as double,
    price: json['price'] as double,
  );
}

Map<String, dynamic> _$AskBidToJson(AskBid instance) => <String, dynamic>{
      'amount': instance.amount,
      'price': instance.price,
    };

TradeItem _$TradeItemFromJson(Map<String, dynamic> json) {
  return TradeItem(
    id: json['id'] as String,
    price: (json['price'] as num).toDouble(),
    amount: (json['amount'] as num).toDouble(),
    total: (json['total'] as num)?.toDouble(),
    createdAt: _createdAtFromJson(json['created_at'] as String),
    marketName: json['marketName'] as String,
    side: json['side'] as String,
    takerType: json['taker_type'] as String,
  );
}

Map<String, dynamic> _$TradeItemToJson(TradeItem instance) => <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'amount': instance.amount,
      'total': instance.total,
      'created_at': _createdAtToJson(instance.createdAt),
      'taker_type': instance.takerType,
      'marketName': instance.marketName,
      'side': instance.side,
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return OrderItem(
    id: json['id'] as int,
    price: json['price'] as String,
    originVolume: json['origin_volume'] as String,
    side: json['side'] as String,
    createdAt: _createdAtFromJson(json['created_at'] as String),
    marketName: json['marketName'] as String,
    market: json['market'] as String,
    state: json['state'] as String,
  );
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'origin_volume': instance.originVolume,
      'side': instance.side,
      'state': instance.state,
      'created_at': _createdAtToJson(instance.createdAt),
      'marketName': instance.marketName,
      'market': instance.market,
    };
