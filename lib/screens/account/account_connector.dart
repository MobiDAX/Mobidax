import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';

import '../../helpers/error_notifier.dart';
import '../../helpers/sizes_helpers.dart';
import '../../web/components/account_page_web.dart';
import 'account_widget.dart';

class AccountPageConnector extends StatelessWidget {
  const AccountPageConnector({
    this.marketsPageCallback,
  });

  final VoidCallback marketsPageCallback;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      onInit: (st) {
        if (st.state.accountUserState.userSession.barongSession != "") {
          st.dispatch(
            OrdersHistoryFetchAction(),
          );
          st.dispatch(
            UserApiKeys(),
          );
        }
        st.dispatch(
          FetchAccountActivities(),
        );
        st.dispatch(
          UpdateUserProfile(),
        );
      },
      onWillChange: (vm) {
        if (vm.success != null) {
          vm.clearError();
          SnackBarNotifier.createSnackBar(
            vm.success,
            context,
            Status.success,
          );
        }
      },
      builder: (BuildContext context, AccountPageModel vm) => isDesktop(context)
          ? WebAccountPage(
              isAuthorized: vm.isAuthorized,
              user: vm.user,
              trades: vm.trades,
              onClickOrderHistory: vm.onClickOrderHistory,
              orders: vm.orders,
              onClickTradeHistory: vm.onClickTradeHistory,
              onClickActivities: vm.onClickActivities,
              onChangePassword: vm.onChangePassword,
              onFetchOrderHistory: vm.onFetchOrderHistory,
              getTradeHistory: vm.getTradeHistory,
              onEnable2FA: vm.onEnable2FA,
              onVerifyEmail: vm.onVerifyEmail,
              selectedIndex: vm.selectedIndex,
              authenteqEnabled: vm.authenteqEnabled,
              onVerifyIdentity: vm.onVerifyIdentity,
              activities: vm.activities,
              onFetchActivities: vm.onFetchActivityHistory,
              onCreateApiKey: vm.onCreateApiKey,
              onDeleteApiKey: vm.onDeleteApiKey,
              onUpdateApiKey: vm.onUpdateApiKey,
              userApiKeys: vm.userApiKeys,
              onLogOut: () {
                vm.onLogOut();
                marketsPageCallback();
              },
              onTabSelect: vm.onTabSelect,
            )
          : AccountPage(
              isAuthorized: vm.isAuthorized,
              user: vm.user,
              trades: vm.trades,
              onClickOrderHistory: vm.onClickOrderHistory,
              orders: vm.orders,
              onClickTradeHistory: vm.onClickTradeHistory,
              onClickActivities: vm.onClickActivities,
              onChangePassword: vm.onChangePassword,
              onFetchOrderHistory: vm.onFetchOrderHistory,
              getTradeHistory: vm.getTradeHistory,
              onEnable2FA: vm.onEnable2FA,
              onVerifyEmail: vm.onVerifyEmail,
              selectedIndex: vm.selectedIndex,
              onVerifyIdentity: vm.onVerifyIdentity,
              onCreateApiKey: vm.onCreateApiKey,
              onDeleteApiKey: vm.onDeleteApiKey,
              onUpdateApiKey: vm.onUpdateApiKey,
              userApiKeys: vm.userApiKeys,
              onLogOut: () {
                vm.onLogOut();
                marketsPageCallback();
              },
              onTabSelect: vm.onTabSelect,
            ),
    );
  }
}
