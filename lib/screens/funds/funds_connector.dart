import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';

import '../../helpers/sizes_helpers.dart';
import '../../web/components/funds_page_web.dart';
import 'funds_widget.dart';

class FundsPageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FundsPageModel>(
      model: FundsPageModel(),
      onInitialBuild: (vm) {
        if (vm.isAuthorized) {
          vm.onFetchBalance();
        }
      },
      onInit: (st) {
        st.dispatch(FetchBalance());
        st.dispatch(GetDepositHistory());
      },
      builder: (BuildContext context, FundsPageModel vm) => isDesktop(context)
          ? FundsPageWeb(
              isAuthorized: vm.isAuthorized,
              balances: vm.balances,
              isFundsLoading: vm.isFundsLoading,
              onFetchBalance: vm.onFetchBalance,
              onShowWallet: vm.onShowWallet,
              deposits: vm.deposits,
              withdrawals: vm.withdrawals,
              selectedBeneficiary: vm.selectedBeneficiary,
              beneficiaries: vm.beneficiaries,
              selectedCardIndex: vm.selectedCardIndex,
              user: vm.user)
          : FundsPage(
              isAuthorized: vm.isAuthorized,
              balances: vm.balances,
              isFundsLoading: vm.isFundsLoading,
              onFetchBalance: vm.onFetchBalance,
              onShowWallet: vm.onShowWallet,
            ),
    );
  }
}
