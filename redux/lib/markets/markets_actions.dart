import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'markets_state.dart';
import '../store.dart';
import '../graphql_client.dart';
import 'dart:async';

List<MarketItemState> combineMarkets(
    List<MarketItemState> fetched, List<MarketItemState> inState) {
  List<MarketItemState> result = [];

  //TODO: Simplify this method
  if (inState.isEmpty) {
    result = fetched;
  } else {
    inState.forEach((inStateMarket) {
      var m = fetched.indexWhere((element) => element.id == inStateMarket.id);
      if (m >= 0) {
        if (!result.contains(inStateMarket)) {
          result.add(inStateMarket.copy(
            ticker: fetched[m].ticker,
            pricePrecision: fetched[m].pricePrecision,
            amountPrecision: fetched[m].amountPrecision,
            baseUnit: fetched[m].baseUnit,
            quoteUnit: fetched[m].quoteUnit,
            selected: inStateMarket.selected,
            isFavourite: inStateMarket.isFavourite,
          ));
        }
        fetched.removeAt(m);
      }
    });
    result += fetched;
  }
  return result;
}

class MarketsFetchAction extends ReduxAction<AppState> {
  final String marketSearch;

  MarketsFetchAction({this.marketSearch = ''});

  static const marketsFetchQuery = r'''
          query markets($marketSearch: String!) {
            markets(search: $marketSearch) {
              id
              name
              amount_precision
    					price_precision
              ticker{
                last
                volume
                price_change_percent
              }
              base_unit{
                id
                name
                icon_url
                symbol
              }
              quote_unit{
                id
                name
                icon_url
                symbol
              }
            }
    }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(marketsFetchQuery),
      variables: <String, dynamic>{
        'marketSearch': marketSearch,
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          marketsPageState: state.marketsPageState.copy(
        marketsLoading: result.loading,
        error: result.exception,
      ));
    } else {
      var res = (result.data['markets'] as List)
          .map((item) => MarketItemState.fromJson(item))
          .toList();

      var combined = combineMarkets(res, state.marketsPageState.marketItems);

      return state.copy(
          marketsPageState: state.marketsPageState
              .copy(marketItems: combined, marketsLoading: false));
    }
  }
}

class MarketSelectFavourite extends ReduxAction<AppState> {
  final MarketItemState marketItem;

  MarketSelectFavourite({@required this.marketItem})
      : assert(marketItem != null);

  @override
  AppState reduce() {
    var newMarketItems =
        state.marketsPageState.marketItems.map((MarketItemState item) {
      if (item == marketItem) {
        if (marketItem.isFavourite)
          return item.copy(isFavourite: false);
        else
          return item.copy(isFavourite: true);
      }
      return item;
    }).toList();

    newMarketItems.sort((MarketItemState a, MarketItemState b) {
      if ((a.isFavourite && b.isFavourite) ||
          (!a.isFavourite && !b.isFavourite)) {
        return 0;
      } else if (a.isFavourite && !b.isFavourite) {
        return -1;
      } else {
        return 1;
      }
    });

    return state.copy(
        marketsPageState: state.marketsPageState.copy(
      marketItems: newMarketItems,
    ));
  }
}

class TickerSubAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    MarketsPageState.substream.listen(
      _onData,
      onError: _onError,
      onDone: _onDone,
    );

    return null;
  }

  void _onData(final FetchResult message) {
    var marketTickers = Map<String, TickerState>.fromIterable(
        message.data['globalTickers'],
        key: (item) => item['id'],
        value: (item) => TickerState.fromJson(item));
    dispatch(TickerUpdateAction(tickers: marketTickers));
  }

  void _onError(final Object error) {
    dispatch(MarketErrorAction(
        error: (error is SubscriptionError) ? error.payload : error));
  }

  void _onDone() {
    debugPrint("Websocket communication is done!");
  }
}

class TickerUpdateAction extends ReduxAction<AppState> {
  final Map<String, TickerState> tickers;

  TickerUpdateAction({this.tickers});

  @override
  AppState reduce() {
    List<MarketItemState> result = [];
    var marketItems = state.marketsPageState.copy().marketItems;
    marketItems.forEach((element) {
      result.add(
        element.copy(ticker: tickers[element.id]),
      );
    });

    return state.copy(
        marketsPageState: state.marketsPageState.copy(
      marketItems: result,
    ));
  }
}

class MarketErrorAction extends ReduxAction<AppState> {
  final Exception error;

  MarketErrorAction({this.error});

  @override
  AppState reduce() {
    return state.copy(
        marketsPageState: state.marketsPageState.copy(
      error: error,
    ));
  }
}
