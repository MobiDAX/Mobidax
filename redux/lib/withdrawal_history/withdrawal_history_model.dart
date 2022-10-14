import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobidax_redux/redux.dart';
import '../store.dart';

class WithdrawalHistoryPageModel extends BaseModel<AppState> {
  final bool isLoading;
  final List<WithdrawalItem> withdrawals;

  WithdrawalHistoryPageModel({this.isLoading, this.withdrawals});

  VoidCallback onWithdrawHistory;

  WithdrawalHistoryPageModel.build(
      {this.isLoading, this.onWithdrawHistory, this.withdrawals})
      : super(equals: [isLoading, withdrawals]);

  @override
  WithdrawalHistoryPageModel fromStore() => WithdrawalHistoryPageModel.build(
      isLoading: state.withdrawalHistoryPageState.isLoading,
      withdrawals: state.fundsPageState.withdrawals,
      onWithdrawHistory: () {
        dispatch(GetWithdrawalHistory());
      });
}
