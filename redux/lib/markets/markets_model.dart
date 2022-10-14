import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/foundation.dart';
import '../exchange/exchange_actions.dart';
import 'markets_actions.dart';
import '../store.dart';
import 'markets_state.dart';

class MarketPageModel extends BaseModel<AppState> {
  bool marketsLoading;
  List<MarketItemState> markets;
  VoidCallback onBuild;
  bool fromNav;
  Function(MarketItemState item) onSelectFavourite;
  Function(MarketItemState item) onTapMarket;
  Function(String text) onSearchBoxChanged;
  Exception error;
  MarketItemState selectedMarket;

  MarketPageModel({this.fromNav});

  MarketPageModel.build({
    @required this.marketsLoading,
    @required this.markets,
    @required this.selectedMarket,
    @required this.onBuild,
    @required this.onSearchBoxChanged,
    @required this.onSelectFavourite,
    @required this.onTapMarket,
    @required this.error,
  }) : super(equals: [
          marketsLoading,
          markets,
          error,
        ]);

  @override
  MarketPageModel fromStore() => MarketPageModel.build(
        marketsLoading: state.marketsPageState.marketsLoading,
        markets: state.marketsPageState.marketItems,
        onSearchBoxChanged: (text) =>
            dispatch(MarketsFetchAction(marketSearch: text)),
        onBuild: () => dispatchFuture(MarketsFetchAction(marketSearch: '')),
        onSelectFavourite: (item) =>
            dispatch(MarketSelectFavourite(marketItem: item)),
        error: state.marketsPageState.error,
        onTapMarket: (item) {
          dispatchFuture(
              SelectMarketAction(marketID: item.id, fromNav: fromNav));
        },
        selectedMarket: state.marketsPageState.marketItems.isNotEmpty
            ? state.marketsPageState.marketItems.firstWhere(
                (element) => element.selected,
                orElse: () => MarketItemState.initialState())
            : MarketItemState.initialState(),
      );
}
