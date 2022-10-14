import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';

import 'withdrawal_history_widget.dart';

class WithdrawalHistoryPageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WithdrawalHistoryPageModel>(
      onInit: (st) {
        st.dispatch(
          GetWithdrawalHistory(),
        );
      },
      model: WithdrawalHistoryPageModel(),
      builder: (BuildContext context, WithdrawalHistoryPageModel vm) =>
          WithdrawalHistoryPage(
        isLoading: vm.isLoading,
        withdrawals: vm.withdrawals,
        onWithdrawHistory: vm.onWithdrawHistory,
      ),
    );
  }
}
