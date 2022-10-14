import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';

import '../../components/bottom_navigation.dart';
import '../../helpers/error_notifier.dart';
import 'markets_widget.dart';

class MarketPageConnector extends StatelessWidget {
  const MarketPageConnector(this.fromNav, this.selectTab, [Key key])
      : super(key: key);

  final fromNav;
  final Function(TabItem tabItem) selectTab;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MarketPageModel>(
      model: MarketPageModel(
        fromNav: fromNav,
      ),
      onInit: (st) {
        st.dispatch(
          MarketsFetchAction(),
        );
      },
      onWillChange: (vm) {
        if (vm.error != null) {
          SnackBarNotifier.createSnackBar(
            tr('unable_to_fetch_markets'),
            context,
            Status.error,
          );
        }
      },
      builder: (BuildContext context, MarketPageModel vm) => MarketPage(
        marketsLoading: vm.marketsLoading,
        fromNav: fromNav,
        selectTab: selectTab,
        markets: vm.markets,
        onBuild: vm.onBuild,
        selectedMarket: vm.selectedMarket,
        onSelectFavourite: vm.onSelectFavourite,
        onSearchBoxChanged: vm.onSearchBoxChanged,
        onTapMarket: vm.onTapMarket,
      ),
    );
  }
}
