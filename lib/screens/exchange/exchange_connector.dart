import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';

import '../../helpers/error_notifier.dart';
import '../../helpers/sizes_helpers.dart';
import '../../web/exchange_widget.dart';
import 'exchange_widget.dart';

// TODO: Integrate selectors for Lists
class ExchangePageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ExchangePageModel>(
      model: ExchangePageModel(),
      onInit: (st) async {
        st.dispatch(MarketsFetchAction());
        st.dispatch(
          MarketTradeFetchAction(
            selectedMarketId: st.state.marketsPageState.marketItems
                .firstWhere(
                  (element) => element.selected == true,
                )
                .id,
          ),
        );
        st.dispatch(
          KlineFetchAction(
            period: st.state.exchangePageState.selectedPeriod,
            selectedMarketId: st.state.marketsPageState.marketItems
                .firstWhere(
                  (element) => element.selected == true,
                )
                .id,
          ),
        );
        st.dispatch(
          KlineSubAction(
            period: st.state.exchangePageState.selectedPeriod,
            selectedMarketId: st.state.marketsPageState.marketItems
                .firstWhere(
                  (element) => element.selected == true,
                )
                .id,
          ),
        );
        st.dispatch(
          OrderbookFetchAction(
            selectedMarketId: st.state.marketsPageState.marketItems
                .firstWhere(
                  (element) => element.selected == true,
                )
                .id,
          ),
        );
        st.dispatch(
          MarketUpdateSubAction(
            selectedMarketId: st.state.marketsPageState.marketItems
                .firstWhere(
                  (element) => element.selected == true,
                )
                .id,
          ),
        );
        st.dispatch(
          MarketTradeSubAction(
            selectedMarketId: st.state.marketsPageState.marketItems
                .firstWhere(
                  (element) => element.selected == true,
                )
                .id,
          ),
        );

        if (st.state.accountUserState.isAuthourized &&
            st.state.exchangePageState.userOrders.isEmpty) {
          st.dispatch(
            UserOrdersFetchAction(
              selectedMarketId: st.state.marketsPageState.marketItems
                  .firstWhere(
                    (element) => element.selected == true,
                  )
                  .id,
              barongSession:
                  st.state.accountUserState.userSession.barongSession,
            ),
          );

          st.dispatch(
            UserOrderSubAction(
              selectedMarketId: st.state.marketsPageState.marketItems
                  .firstWhere(
                    (element) => element.selected == true,
                  )
                  .id,
              barongSession:
                  st.state.accountUserState.userSession.barongSession,
            ),
          );
        }

        if (st.state.accountUserState.isAuthourized &&
            st.state.exchangePageState.userTrades.isEmpty) {
          st.dispatch(UserTradeFetchAction(
              selectedMarketId: st.state.marketsPageState.marketItems
                  .firstWhere(
                    (element) => element.selected == true,
                  )
                  .id,
              barongSession:
                  st.state.accountUserState.userSession.barongSession));
          st.dispatch(
            UserTradeSubAction(
              selectedMarketId: st.state.marketsPageState.marketItems
                  .firstWhere(
                    (element) => element.selected == true,
                  )
                  .id,
              barongSession:
                  st.state.accountUserState.userSession.barongSession,
            ),
          );
        }
      },
      onWillChange: (vm) {
        if (vm.error != null) {
          vm.clearError();
          SnackBarNotifier.createSnackBar(
            tr(vm.error.graphqlErrors.first.message) ?? 'Something went wrong',
            context,
            Status.error,
          );
        }
        if (vm.sucess != null) {
          vm.clearError();
          SnackBarNotifier.createSnackBar(
            vm.sucess,
            context,
            Status.success,
          );
        }
      },
      builder: (BuildContext context, ExchangePageModel vm) =>
          displayWidth(context) > 700
              ? WebExchangePage(
                  onMarketSeletor: vm.onMarketSelector,
                  selectedMarket: vm.selectedMarket,
                  onPlaceOrder: vm.onPlaceOrder,
                  onCancelOrder: vm.onCancelOrder,
                  isLoading: vm.isLoading,
                  isOrderbook: vm.isOrderbook,
                  onSwitchSelect: vm.onSwitchSelect,
                  onTabSelect: vm.onTabSelect,
                  onPeriodSelect: vm.onPeriodSelect,
                  selectedPeriod: vm.selectedPeriod,
                  onOrderSelect: vm.onOrderSelect,
                  selectedTabIndex: vm.selectedTabIndex,
                  klineState: vm.klineState,
                  orderbook: vm.orderbook,
                  onFetchMore: vm.onFetchMore,
                  marketTrades: vm.marketTrades,
                  isAuthourized: vm.isAuthourized,
                  cancelAllOrders: vm.cancelAllOrders,
                  userTrades: vm.userTrades,
                  balances: vm.balances,
                  userOrders: vm.userOrders,
                  userSession: vm.userSession,
                )
              : ExchangePage(
                  onMarketSeletor: vm.onMarketSelector,
                  selectedMarket: vm.selectedMarket,
                  onPlaceOrder: vm.onPlaceOrder,
                  onCancelOrder: vm.onCancelOrder,
                  isLoading: vm.isLoading,
                  isOrderbook: vm.isOrderbook,
                  onSwitchSelect: vm.onSwitchSelect,
                  onTabSelect: vm.onTabSelect,
                  onPeriodSelect: vm.onPeriodSelect,
                  selectedPeriod: vm.selectedPeriod,
                  onOrderSelect: vm.onOrderSelect,
                  selectedTabIndex: vm.selectedTabIndex,
                  klineState: vm.klineState,
                  orderbook: vm.orderbook,
                  onFetchMore: vm.onFetchMore,
                  marketTrades: vm.marketTrades,
                  isAuthourized: vm.isAuthourized,
                  cancelAllOrders: vm.cancelAllOrders,
                  userTrades: vm.userTrades,
                  balances: vm.balances,
                  userOrders: vm.userOrders,
                  userSession: vm.userSession,
                ),
    );
  }
}
