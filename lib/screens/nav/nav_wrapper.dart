import 'package:async_redux/async_redux.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';

import '../../components/bottom_navigation.dart';
import '../../helpers/double_call_filter.dart';
import '../account/account_connector.dart';
import '../exchange/exchange_connector.dart';
import '../funds/funds_connector.dart';
import '../home/home_widget.dart';
import '../markets/markets_connector.dart';

class NavScreenConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, Object> defaultTabItem =
        ModalRoute.of(context).settings.arguments;
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      builder: (BuildContext context, AccountPageModel vm) => NavScreen(
        onGetStarted: vm.onGetStarted,
        homeVisited: vm.homeVisited,
        isAuthorized: vm.isAuthorized,
        defaultTabItem:
            (defaultTabItem != null) ? defaultTabItem['_currentTab'] : '',
      ),
    );
  }
}

class NavScreen extends StatefulWidget {
  const NavScreen({
    this.isAuthorized,
    this.homeVisited,
    this.onGetStarted,
    this.defaultTabItem,
  });

  final bool isAuthorized;
  final bool homeVisited;
  final Function() onGetStarted;
  final String defaultTabItem;

  @override
  State<StatefulWidget> createState() => NavigationWrapper();
}

class NavigationWrapper extends State<NavScreen> {
  TabItem _currentTab = TabItem.markets;

  void selectTab(TabItem tabItem) {
    if (!widget.isAuthorized &&
        (tabItem == TabItem.account || tabItem == TabItem.funds)) {
      Navigator.of(context).pushNamed('/signInPage');
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  void initState() {
    switch (widget.defaultTabItem) {
      case '/funds':
        {
          _currentTab = TabItem.funds;
          break;
        }
      case '/account':
        {
          _currentTab = TabItem.account;
          break;
        }
      default:
        {
          _currentTab = TabItem.exchange;
        }
    }
    // TODO: implement initState
    super.initState();
    _retrieveDynamicLink();
  }

  void _retrieveDynamicLink() async {
    var dynamicLink = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = dynamicLink?.link;
    if (deepLink != null) {
      if (deepLink.queryParameters['confirmation_token'] != null) {
        Navigator.pushNamed(
          context,
          '/emailConfirmation',
          arguments: {
            'token': deepLink.queryParameters['confirmation_token'],
          },
        );
      }

      if (deepLink.queryParameters['reset_token'] != null) {
        Navigator.pushNamed(
          context,
          '/resetPassword',
          arguments: {
            'token': deepLink.queryParameters['reset_token'],
          },
        );
      }
    }

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: DoubleCallFilter<PendingDynamicLinkData>(
        action: (dynamicLink) async {
          print('onSuccess');
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            if (deepLink.queryParameters['confirmation_token'] != null) {
              Navigator.pushNamed(
                context,
                '/emailConfirmation',
                arguments: {
                  'token': deepLink.queryParameters['confirmation_token'],
                },
              );
            }

            if (deepLink.queryParameters['reset_token'] != null) {
              Navigator.pushNamed(
                context,
                '/resetPassword',
                arguments: {
                  'token': deepLink.queryParameters['reset_token'],
                },
              );
            }
          }
        },
      ),
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.homeVisited
        ? Scaffold(
            appBar: _currentTab != TabItem.exchange
                ? AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 8,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    centerTitle: true,
                    title: Text(
                      namedTab(_currentTab),
                      style:
                          Theme.of(context).primaryTextTheme.headline6.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                    ),
                  )
                : null,
            body: selectPage(
              _currentTab,
              selectTab,
              () => setState(
                () => _currentTab = TabItem.markets,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            bottomNavigationBar: SafeArea(
              child: BottomNavigation(
                currentTab: _currentTab,
                onSelectTab: selectTab,
              ),
            ),
          )
        : HomePage(
            onGetStarted: widget.onGetStarted,
          );
  }
}

Widget selectPage(TabItem currentRoute, Function(TabItem tabItem) selectTab,
    VoidCallback maketsPageCallback) {
  switch (currentRoute) {
    case TabItem.markets:
      {
        return MarketPageConnector(true, selectTab);
      }
    case TabItem.exchange:
      {
        return ExchangePageConnector();
      }
    case TabItem.funds:
      {
        return FundsPageConnector();
      }
    case TabItem.account:
      {
        return AccountPageConnector(
          marketsPageCallback: maketsPageCallback,
        );
      }
    default:
      {
        return MarketPageConnector(true, selectTab);
      }
  }
}
