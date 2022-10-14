import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:mobidax_redux/redux.dart';
import '../store.dart';

class ConfirmBeneficiaryPageModel extends BaseModel<AppState> {
  final OperationException error;
  final Beneficiary createdBeneficiary;

  ConfirmBeneficiaryPageModel({this.error, this.createdBeneficiary});
  Function(int id, String pin) onConfirmBeneficiary;
  VoidCallback clearError;

  ConfirmBeneficiaryPageModel.build(
      {this.error,
      this.clearError,
      this.onConfirmBeneficiary,
      this.createdBeneficiary})
      : super(equals: [error, createdBeneficiary]);

  @override
  ConfirmBeneficiaryPageModel fromStore() => ConfirmBeneficiaryPageModel.build(
      error: state.confirmBeneficiaryPageState.error,
      clearError: () {
        dispatch(ClearBeneficiaryConfirmErrorAction());
      },
      onConfirmBeneficiary: (id, pin) {
        dispatch(ConfirmBeneficiaryAction(id: id, pin: pin));
      },
      createdBeneficiary: state.confirmBeneficiaryPageState.createdBeneficiary);
}
