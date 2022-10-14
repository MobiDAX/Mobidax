import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobidax_redux/redux.dart';
import '../helpers.dart';
import '../store.dart';
import '../graphql_client.dart';

class ClearWithdrawalErrorAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return state.copy(
        withdrawalPageState: state.withdrawalPageState.copy(error: null));
  }
}

class CreateWithdrawalAction extends ReduxAction<AppState> {
  final String currency;
  final int beneficiaryId;
  final double amount;
  final String otp;
  final String note;

  CreateWithdrawalAction(
      {this.currency, this.beneficiaryId, this.amount, this.otp, this.note});

  static const CreateWithdrawalMutation = r'''
            mutation createWithdrawal($_barong_session: String!, $otp: String!, $beneficiary_id: Int!, $currency: String!,$amount: Float!, $note: String ){
              createWithdrawal(_barong_session:$_barong_session,otp:$otp,beneficiary_id:$beneficiary_id,currency:$currency,amount:$amount,note:$note) {
                id
                currency
                type
                amount
                fee
                blockchain_txid
                rid
                state
                confirmations
                note
                created_at
                updated_at
                done_at
              }
            }
        ''';

  @override
  Future<AppState> reduce() async {
    var barongSession = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(CreateWithdrawalMutation),
      variables: <String, dynamic>{
        '_barong_session': barongSession,
        'currency': currency,
        'amount': amount,
        'beneficiary_id': beneficiaryId,
        'otp': otp,
        'note': note
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          withdrawalPageState:
              state.withdrawalPageState.copy(error: result.exception));
    } else {
      Fluttertoast.showToast(
          msg: "$amount ${currency.toUpperCase()} ${tr('withdrawal_success')}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: "center",
          webBgColor: toHex(Colors.green),
          fontSize: 16.0);

      dispatch(GetWithdrawalHistory());
      dispatch(FetchBalance());
      dispatch(NavigateAction.pop());
      return null;
    }
  }
}
