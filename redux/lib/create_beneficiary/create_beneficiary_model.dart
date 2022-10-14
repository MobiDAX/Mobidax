import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'package:mobidax_redux/redux.dart';
import '../store.dart';

class CreateBeneficiaryPageModel extends BaseModel<AppState> {
  final OperationException error;
  final bool loading;
  final CurrencyItemState currency;

  CreateBeneficiaryPageModel({this.error, this.loading, this.currency});

  Function(String address, String description, String name, String currency)
      onCreateBeneficiary;
  Function(String name, String fullName, String accountNumber, String bankName,
      String currency) onCreateFiatBeneficiary;
  VoidCallback clearError;
  CreateBeneficiaryPageModel.build({
    this.onCreateBeneficiary,
    this.onCreateFiatBeneficiary,
    this.error,
    this.loading,
    this.currency,
    this.clearError,
  }) : super(equals: [error, loading]);

  @override
  CreateBeneficiaryPageModel fromStore() => CreateBeneficiaryPageModel.build(
        onCreateBeneficiary:
            (String address, String description, String name, String currency) {
          dispatch(CreateBeneficiaryAction(
              address: address,
              description: description,
              name: name,
              currency: currency));
        },
        onCreateFiatBeneficiary: (String name, String fullName,
            String accountNumber, String bankName, String currency) {
          dispatch(CreateFiatBeneficiaryAction(
              fullName: fullName,
              accountNumber: accountNumber,
              name: name,
              bankName: bankName,
              currency: currency));
        },
        error: state.createBeneficiaryPageState.error,
        loading: state.createBeneficiaryPageState.loading,
        currency: state.accountUserState
            .balances[state.walletPageState.selectedCardIndex].currency,
        clearError: () {
          dispatch(ClearBeneficiaryErrorAction());
        },
      );
}
