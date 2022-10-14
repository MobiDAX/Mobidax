import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';

import '../../components/nav_drawer/custom_navigation_drawer.dart';
import '../../web/components/history_page_connector.dart';
import '../account/account_connector.dart';
import '../exchange/exchange_connector.dart';
import '../funds/funds_connector.dart';
import '../home/home_widget.dart';

class NavWebScreenConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, Object> defaultTabWebItem =
        ModalRoute.of(context).settings.arguments;

    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      onInit: (st) {
        var selectedMarketId = st.state.marketsPageState.marketItems
            .firstWhere((element) => element.selected == true,
                orElse: () => st.state.marketsPageState.marketItems.first)
            .id;
        st.dispatch(
          MarketTradeFetchAction(
            selectedMarketId: selectedMarketId,
          ),
        );
        st.dispatch(
          KlineFetchAction(
            period: st.state.exchangePageState.selectedPeriod,
            selectedMarketId: selectedMarketId,
          ),
        );
        st.dispatch(
          KlineSubAction(
            period: st.state.exchangePageState.selectedPeriod,
            selectedMarketId: selectedMarketId,
          ),
        );
        st.dispatch(
          OrderbookFetchAction(
            selectedMarketId: selectedMarketId,
          ),
        );
        st.dispatch(
          MarketUpdateSubAction(
            selectedMarketId: selectedMarketId,
          ),
        );
        st.dispatch(
          MarketTradeSubAction(
            selectedMarketId: selectedMarketId,
          ),
        );
      },
      builder: (BuildContext context, AccountPageModel vm) => NavWebScreen(
          user: vm.user,
          onGetStarted: vm.onGetStarted,
          homeVisited: vm.homeVisited,
          onLogOut: vm.onLogOut,
          isAuthorized: vm.isAuthorized,
          defaultTabWebItem: (defaultTabWebItem != null)
              ? defaultTabWebItem['_currentTab']
              : ''),
    );
  }
}

class NavWebScreen extends StatefulWidget {
  const NavWebScreen({
    this.isAuthorized,
    this.homeVisited,
    this.onGetStarted,
    this.user,
    this.onLogOut,
    this.defaultTabWebItem,
  });

  final bool isAuthorized;
  final bool homeVisited;
  final Function() onGetStarted;
  final Function onLogOut;
  final UserState user;
  final String defaultTabWebItem;

  @override
  State<StatefulWidget> createState() => WebNavigationWrapper();
}

class WebNavigationWrapper extends State<NavWebScreen> {
  WebTabItem _currentTab = WebTabItem.exchange;

  void selectTab(WebTabItem tabItem) {
    if (!widget.isAuthorized &&
        (tabItem == WebTabItem.account ||
            tabItem == WebTabItem.funds ||
            tabItem == WebTabItem.history)) {
      Navigator.of(context).pushNamed('/signInPage');
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  void initState() {
    switch (widget.defaultTabWebItem) {
      case '/funds':
        {
          _currentTab = WebTabItem.funds;
          break;
        }
      case '/account':
        {
          _currentTab = WebTabItem.account;
          break;
        }
      default:
        {
          _currentTab = WebTabItem.exchange;
        }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.homeVisited
        ? Scaffold(
            body: Stack(children: <Widget>[
              _currentTab != WebTabItem.exchange
                  ? Image(
                      image: const AssetImage(
                        'assets/icons/waves.png',
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.fill,
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(
                  left: 70.0,
                ),
                child: selectPage(
                  _currentTab,
                  selectTab,
                  () => setState(
                    () => _currentTab = WebTabItem.exchange,
                  ),
                ),
              ),
              SafeArea(
                child: CollapsingNavigationDrawer(
                    email: widget.user != null ? widget.user.email : '',
                    currentTab: _currentTab,
                    onSelectTab: selectTab,
                    onLogOut: widget.onLogOut,
                    isAuthorized: widget.isAuthorized),
              )
            ]),
            backgroundColor: _currentTab == WebTabItem.exchange
                ? Theme.of(context).colorScheme.primaryVariant
                : Theme.of(context).colorScheme.background,
          )
        : HomePage(
            onGetStarted: widget.onGetStarted,
          );
  }
}

Widget selectPage(WebTabItem currentRoute,
    Function(WebTabItem tabItem) selectTab, VoidCallback marketsPageCallback) {
  switch (currentRoute) {
    case WebTabItem.exchange:
      {
        return ExchangePageConnector();
      }
    case WebTabItem.funds:
      {
        return FundsPageConnector();
      }
    case WebTabItem.account:
      {
        return AccountPageConnector(
          marketsPageCallback: marketsPageCallback,
        );
      }
    case WebTabItem.history:
      {
        return HistoryPageConnector();
      }
    default:
      {
        return ExchangePageConnector();
      }
  }
}
