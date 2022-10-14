// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markets_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketsPageState _$MarketsPageStateFromJson(Map<String, dynamic> json) {
  return MarketsPageState(
    marketItems: (json['marketItems'] as List)
        .map((e) => MarketItemState.fromJson(e as Map<String, dynamic>))
        .toList(),
    marketsLoading: json['marketsLoading'] as bool,
  );
}

Map<String, dynamic> _$MarketsPageStateToJson(MarketsPageState instance) =>
    <String, dynamic>{
      'marketItems': instance.marketItems,
      'marketsLoading': instance.marketsLoading,
    };

MarketItemState _$MarketItemStateFromJson(Map<String, dynamic> json) {
  return MarketItemState(
    id: json['id'] as String,
    name: json['name'] as String,
    pricePrecision: json['price_precision'] as int,
    amountPrecision: json['amount_precision'] as int,
    ticker: TickerState.fromJson(json['ticker'] as Map<String, dynamic>),
    baseUnit:
        CurrencyItemState.fromJson(json['base_unit'] as Map<String, dynamic>),
    quoteUnit:
        CurrencyItemState.fromJson(json['quote_unit'] as Map<String, dynamic>),
    isFavourite: json['isFavourite'] as bool ?? false,
  );
}

Map<String, dynamic> _$MarketItemStateToJson(MarketItemState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price_precision': instance.pricePrecision,
      'amount_precision': instance.amountPrecision,
      'ticker': instance.ticker,
      'base_unit': instance.baseUnit,
      'quote_unit': instance.quoteUnit,
      'isFavourite': instance.isFavourite,
    };

TickerState _$TickerStateFromJson(Map<String, dynamic> json) {
  return TickerState(
    last: (json['last'] as num).toDouble(),
    volume: (json['volume'] as num).toDouble(),
    priceChangePercent: json['price_change_percent'] as String,
  );
}

Map<String, dynamic> _$TickerStateToJson(TickerState instance) =>
    <String, dynamic>{
      'last': instance.last,
      'volume': instance.volume,
      'price_change_percent': instance.priceChangePercent,
    };
