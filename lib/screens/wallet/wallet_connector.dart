import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';

import '../../helpers/error_notifier.dart';
import 'wallet_widget.dart';

class WalletPageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WalletPageModel>(
      model: WalletPageModel(),
      onWillChange: (vm) {
        if (vm.error != null) {
          vm.clearError();
          SnackBarNotifier.createSnackBar(
            tr(vm.error.graphqlErrors.first.message) ?? 'Something went wrong',
            context,
            Status.error,
          );
        }
      },
      builder: (BuildContext context, WalletPageModel vm) => WalletPage(
        onTabSelect: vm.onTabSelect,
        selectedTabIndex: vm.selectedTabIndex,
        onWithdrawal: vm.onWithdrawal,
        onAddBeneficiary: vm.onAddBeneficiary,
        onWithdrawalHistory: vm.onWithdrawalHistory,
        onDepositHistory: vm.onDepositHistory,
        balances: vm.balances,
        beneficiaries: vm.beneficiaries,
        selectedCardIndex: vm.selectedCardIndex,
        selectedBeneficiary: vm.selectedBeneficiary,
        user: vm.user,
        onCardSelect: vm.onCardSelect,
      ),
    );
  }
}
