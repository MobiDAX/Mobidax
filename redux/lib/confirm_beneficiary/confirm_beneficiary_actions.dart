import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobidax_redux/account/account_actions.dart';
import '../helpers.dart';
import '../store.dart';
import '../graphql_client.dart';

class ConfirmBeneficiaryAction extends ReduxAction<AppState> {
  final int id;
  final String pin;

  ConfirmBeneficiaryAction({
    this.id,
    this.pin,
  });

  static const ConfirmBeneficiaryMutation = r'''
          mutation activateBeneficiary($_barong_session: String!, $id: Int!, $pin: String!) {
            activateBeneficiary(_barong_session: $_barong_session, id: $id, pin: $pin){
              id
              name
              currency
              address
              description
              state
            }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    var barongSession = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(ConfirmBeneficiaryMutation),
      variables: <String, dynamic>{
        '_barong_session': barongSession,
        'id': id,
        'pin': pin,
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);
    if (result.hasException) {
      Fluttertoast.showToast(
          msg: tr('${result.exception.graphqlErrors[0].message}'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: "center",
          webBgColor: toHex(Colors.red),
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: tr('beneficiary_confirm_success'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: "center",
          webBgColor: toHex(Colors.green),
          fontSize: 16.0);

      dispatch(GetBeneficiaries());
      dispatch(NavigateAction.popUntil('/beneficiaryList'));
      return state.copy(
          createBeneficiaryPageState:
              state.createBeneficiaryPageState.copy(loading: false));
    }
  }
}

class ClearBeneficiaryConfirmErrorAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return state.copy(
        confirmBeneficiaryPageState:
            state.confirmBeneficiaryPageState.copy(error: null));
  }
}
