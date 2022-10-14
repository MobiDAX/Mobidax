import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../helpers/sizes_helpers.dart';

enum TabItem { markets, exchange, funds, account }

Map<TabItem, String> tabName = {
  TabItem.markets: '/markets',
  TabItem.exchange: '/exchange',
  TabItem.funds: '/funds',
  TabItem.account: '/account',
};

String namedTab(TabItem tab) {
  switch (tab) {
    case TabItem.markets:
      return tr('markets');
    case TabItem.exchange:
      return tr('exchange');
    case TabItem.account:
      return tr('account');
    case TabItem.funds:
      return tr('funds');
    default:
      return "";
  }
}

/// Takes up 0.1 of Display Screen.
class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    this.currentTab,
    this.onSelectTab,
  });

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final tabIconTheme = IconThemeData(
      color: Theme.of(context).colorScheme.onPrimary,
      size: MediaQuery.of(context).orientation == Orientation.portrait
          ? displayHeight(context) * 0.04
          : displayWidth(context) * 0.04,
    );
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? displayHeight(context) * 0.1
          : displayWidth(context) * 0.1,
      child: BottomNavigationBar(
        elevation: 8,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedLabelStyle: Theme.of(context).textTheme.bodyText2,
        unselectedLabelStyle: Theme.of(context).textTheme.bodyText2,
        selectedIconTheme: tabIconTheme.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        unselectedIconTheme: tabIconTheme.copyWith(
          color: Theme.of(context).colorScheme.primaryVariant,
        ),
        unselectedItemColor: Theme.of(context).colorScheme.primaryVariant,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.trending_up,
            ),
            label: tr('markets'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.compare_arrows,
            ),
            label: tr('exchange'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.account_balance_wallet,
            ),
            label: tr('funds'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.account_circle,
            ),
            label: tr('account'),
          ),
        ],
        onTap: (index) => onSelectTab(
          TabItem.values[index],
        ),
        currentIndex: currentTab.index,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
