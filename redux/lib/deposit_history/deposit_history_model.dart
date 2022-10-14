import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobidax_redux/redux.dart';
import '../store.dart';

class DepositHistoryPageModel extends BaseModel<AppState> {
  final bool isLoading;
  final List<DepositItem> deposits;
  final String explorerTransaction;

  DepositHistoryPageModel(
      {this.isLoading, this.deposits, this.explorerTransaction});

  VoidCallback onDepositHistory;

  DepositHistoryPageModel.build(
      {this.isLoading,
      this.onDepositHistory,
      this.deposits,
      this.explorerTransaction})
      : super(equals: [isLoading, deposits, explorerTransaction]);

  @override
  DepositHistoryPageModel fromStore() => DepositHistoryPageModel.build(
      isLoading: state.depositHistoryPageState.isLoading,
      deposits: state.fundsPageState.deposits,
      explorerTransaction: state
          .accountUserState
          .balances[state.walletPageState.selectedCardIndex]
          .currency
          .explorerTransaction,
      onDepositHistory: () {
        dispatch(GetDepositHistory());
      });
}
