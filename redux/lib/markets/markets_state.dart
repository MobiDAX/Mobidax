import 'dart:async';
import 'package:graphql/internal.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobidax_redux/account/account_state.dart';
import '../graphql_client.dart';

part 'markets_state.g.dart';

@JsonSerializable(nullable: false, disallowUnrecognizedKeys: false)
class MarketsPageState {
  static Stream<FetchResult> substream =
      GraphQLClientAPI.subStream('globalTickers', r'''
          subscription globalTickers {
            globalTickers {
              id,
              volume,
              last,
              open,
              price_change_percent
            }
          }
        ''');

  final List<MarketItemState> marketItems;
  final bool marketsLoading;

  @JsonKey(ignore: true)
  final Exception error;

  MarketsPageState({this.marketItems, this.marketsLoading = true, this.error});

  MarketsPageState copy(
          {List<MarketItemState> marketItems,
          bool marketsLoading,
          Exception error}) =>
      MarketsPageState(
          marketItems: marketItems ?? this.marketItems,
          error: error,
          marketsLoading: marketsLoading ?? this.marketsLoading);

  factory MarketsPageState.fromJson(Map<String, dynamic> json) =>
      _$MarketsPageStateFromJson(json);
  Map<String, dynamic> toJson() => _$MarketsPageStateToJson(this);

  static MarketsPageState initialState() =>
      MarketsPageState(marketItems: [], marketsLoading: true, error: null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarketsPageState &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          marketItems == other.marketItems &&
          marketsLoading == other.marketsLoading;

  @override
  int get hashCode =>
      marketItems.hashCode ^ marketsLoading.hashCode ^ error.hashCode;
}

@JsonSerializable(nullable: false)
class MarketItemState {
  final String id;
  final String name;
  @JsonKey(name: "price_precision")
  final int pricePrecision;
  @JsonKey(name: "amount_precision")
  final int amountPrecision;
  final TickerState ticker;
  @JsonKey(name: "base_unit")
  final CurrencyItemState baseUnit;
  @JsonKey(name: "quote_unit")
  final CurrencyItemState quoteUnit;
  @JsonKey(nullable: true, defaultValue: false)
  final bool isFavourite;
  @JsonKey(ignore: true)
  final bool selected;

  MarketItemState(
      {this.id = '',
      this.name = '',
      this.pricePrecision = 4,
      this.amountPrecision = 4,
      this.ticker,
      this.baseUnit,
      this.quoteUnit,
      this.isFavourite = false,
      this.selected = true});

  MarketItemState copy(
          {String id,
          String name,
          int pricePrecision,
          int amountPrecision,
          TickerState ticker,
          CurrencyItemState quoteUnit,
          CurrencyItemState baseUnit,
          bool isFavourite,
          bool selected}) =>
      MarketItemState(
        id: id ?? this.id,
        name: name ?? this.name,
        pricePrecision: pricePrecision ?? this.pricePrecision,
        amountPrecision: amountPrecision ?? this.amountPrecision,
        baseUnit: baseUnit ?? this.baseUnit,
        quoteUnit: quoteUnit ?? this.quoteUnit,
        ticker: ticker ?? this.ticker,
        selected: selected ?? this.selected,
        isFavourite: isFavourite ?? this.isFavourite,
      );

  factory MarketItemState.fromJson(Map<String, dynamic> json) =>
      _$MarketItemStateFromJson(json);
  Map<String, dynamic> toJson() => _$MarketItemStateToJson(this);

  static MarketItemState initialState() => MarketItemState(
      id: '',
      name: '',
      amountPrecision: 2,
      pricePrecision: 2,
      baseUnit: CurrencyItemState.initialState(),
      quoteUnit: CurrencyItemState.initialState(),
      isFavourite: false,
      selected: false,
      ticker: TickerState.initialState());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarketItemState &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          pricePrecision == other.pricePrecision &&
          baseUnit == other.baseUnit &&
          quoteUnit == other.quoteUnit &&
          amountPrecision == other.amountPrecision &&
          isFavourite == other.isFavourite &&
          ticker == other.ticker;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      ticker.hashCode ^
      baseUnit.hashCode ^
      quoteUnit.hashCode ^
      isFavourite.hashCode ^
      pricePrecision.hashCode ^
      amountPrecision.hashCode;
}

@JsonSerializable(nullable: false)
class TickerState {
  final double last;
  final double volume;
  @JsonKey(name: 'price_change_percent')
  final String priceChangePercent;

  TickerState({this.last = 0, this.volume = 0.0, this.priceChangePercent = ''});

  TickerState copy({double last, String volume, String priceChangePercent}) =>
      TickerState(
          last: last ?? this.last,
          volume: volume ?? this.volume,
          priceChangePercent: priceChangePercent ?? this.priceChangePercent);

  factory TickerState.fromJson(Map<String, dynamic> json) =>
      _$TickerStateFromJson(json);
  Map<String, dynamic> toJson() => _$TickerStateToJson(this);

  static TickerState initialState() =>
      TickerState(last: 0.0, volume: 0.0, priceChangePercent: "+0.00%");

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TickerState &&
          runtimeType == other.runtimeType &&
          last == other.last &&
          volume == other.volume &&
          priceChangePercent == other.priceChangePercent;

  @override
  int get hashCode =>
      last.hashCode ^ volume.hashCode ^ priceChangePercent.hashCode;
}
