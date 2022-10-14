import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';

import 'deposit_history_widget.dart';

class DepositHistoryPageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DepositHistoryPageModel>(
      onInit: (st) {
        st.dispatch(
          GetDepositHistory(),
        );
      },
      model: DepositHistoryPageModel(),
      builder: (BuildContext context, DepositHistoryPageModel vm) =>
          DepositHistoryPage(
        isLoading: vm.isLoading,
        onDepositHistory: vm.onDepositHistory,
        explorerTransaction: vm.explorerTransaction,
        deposits: vm.deposits,
      ),
    );
  }
}
