import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:mobidax_redux/redux.dart';
import '../store.dart';

class WithdrawalPageModel extends BaseModel<AppState> {
  final OperationException error;
  final Beneficiary selectedBeneficiary;

  VoidCallback clearError;
  Function(String currency, int beneficiaryId, double amount, String otp)
      onWithdraw;

  WithdrawalPageModel({this.error, this.selectedBeneficiary});

  WithdrawalPageModel.build(
      {this.error, this.clearError, this.selectedBeneficiary, this.onWithdraw})
      : super(equals: [error, selectedBeneficiary]);

  @override
  WithdrawalPageModel fromStore() => WithdrawalPageModel.build(
      error: state.withdrawalPageState.error,
      selectedBeneficiary: state.walletPageState.selectedBeneficiary,
      onWithdraw:
          (String currency, int beneficiaryId, double amount, String otp) {
        dispatch(CreateWithdrawalAction(
            currency: currency,
            beneficiaryId: beneficiaryId,
            amount: amount,
            otp: otp));
      },
      clearError: () {
        dispatch(ClearWithdrawalErrorAction());
      });
}
