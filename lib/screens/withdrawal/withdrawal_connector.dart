import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';

import '../../helpers/error_notifier.dart';
import 'withdrawal_widget.dart';

class WithdrawalPageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WithdrawalPageModel>(
      model: WithdrawalPageModel(),
      onWillChange: (vm) {
        if (vm.error != null) {
          vm.clearError();
          SnackBarNotifier.createSnackBar(
            tr('account.withdraw.invalid_otp'),
            context,
            Status.error,
          );
        }
      },
      builder: (BuildContext context, WithdrawalPageModel vm) => WithdrawalPage(
        selectedBeneficiary: vm.selectedBeneficiary,
        onWithdraw: vm.onWithdraw,
      ),
    );
  }
}
