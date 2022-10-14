import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql/client.dart';
import 'package:mobidax_redux/account/account_actions.dart';
import 'package:mobidax_redux/helper/validate_session.dart';
import '../store.dart';
import '../helpers.dart';
import '../graphql_client.dart';

class GetSecret extends ReduxAction<AppState> {
  String session;
  String secret;
  Pattern pattern = r'secret=(\w+)';

  static const getSecret = r'''
                mutation AskOTP($_barong_session: String!){
                  askQRCodeOTP(_barong_session: $_barong_session){
                    barcode,
                    url
                  }
                }
        ''';

  @override
  Future<AppState> reduce() async {
    if (validateSession(
        state.accountUserState.userSession.barongSessionExpires)) {
      if (state.accountUserState.userSession.barongSessionExpires != '')
        dispatch(DestroySessionAction());
      return null;
    } else {
      session = state.accountUserState.userSession.barongSession;
      if (!state.accountUserState.user.otp) {
        final QueryOptions options = QueryOptions(
          documentNode: gql(getSecret),
          variables: <String, dynamic>{'_barong_session': session},
        );

        final QueryResult result =
            await GraphQLClientAPI.client().query(options);
        if (!result.hasException) {
          var res = result.data['askQRCodeOTP']['url'];
          RegExp regex = new RegExp(pattern);
          secret = regex.firstMatch(res).group(0).split('secret=')[1];
          return state.copy(
            enable2faPageState: state.enable2faPageState.copy(secret: secret),
          );
        } else {
          if (result.exception.toString().contains('authz.invalid_session'))
            dispatch(DestroySessionAction());
          return state.copy(
              accountUserState:
                  state.accountUserState.copy(error: result.exception));
        }
      } else {
        return null;
      }
    }
  }
}

class Manage2FA extends ReduxAction<AppState> {
  final String code;
  String session;

  static const enableOTP = r'''
                mutation enableOTP($_barong_session: String!, $code: String!) {
                  enableOTP(_barong_session: $_barong_session, code: $code) {
                    data
                  }
                }
        ''';

  static const disableOTP = r'''
              mutation disableOTP($_barong_session: String!, $code: String!) {
                disableOTP(_barong_session: $_barong_session, code: $code) {
                  data
                }
              }
        ''';

  Manage2FA({this.code});

  @override
  void after() {
    // TODO: implement after
    dispatch(UpdateUserProfile());
    super.after();
  }

  @override
  Future<AppState> reduce() async {
    session = state.accountUserState.userSession.barongSession;
    if (validateSession(
        state.accountUserState.userSession.barongSessionExpires)) {
      if (state.accountUserState.userSession.barongSessionExpires != '')
        dispatch(DestroySessionAction());
      return null;
    } else {
      if (state.accountUserState.user.otp) {
        final QueryOptions options = QueryOptions(
          documentNode: gql(disableOTP),
          variables: <String, dynamic>{
            '_barong_session': session,
            'code': code
          },
        );
        final QueryResult result =
            await GraphQLClientAPI.client().query(options);
        if (result.hasException) {
          if (result.exception.toString().contains('authz.invalid_session'))
            dispatch(DestroySessionAction());

          return state.copy(
              accountUserState:
                  state.accountUserState.copy(error: result.exception));
        }

        if (result.data['disableOTP']['data'] == 'ok') {
          Fluttertoast.showToast(
              msg: tr('disable_2fa_success'),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              webShowClose: true,
              webPosition: "center",
              webBgColor: toHex(Colors.green),
              fontSize: 16.0);
          dispatch(NavigateAction.pop());
          return state.copy(
              accountUserState: state.accountUserState
                  .copy(user: state.accountUserState.user.copy(otp: false)));
        }
      } else {
        final QueryOptions options = QueryOptions(
          documentNode: gql(enableOTP),
          variables: <String, dynamic>{
            '_barong_session': session,
            'code': code
          },
        );

        final QueryResult result =
            await GraphQLClientAPI.client().query(options);

        if (result.hasException) {
          if (result.exception.toString().contains('authz.invalid_session'))
            dispatch(DestroySessionAction());
          dispatch(NavigateAction.pushNamedAndRemoveAll('/',
              arguments: {'_currentTab': '/account'}));
          return state.copy(
              accountUserState:
                  state.accountUserState.copy(error: result.exception));
        }

        if (result.data['enableOTP']['data'] == 'ok') {
          Fluttertoast.showToast(
              msg: tr('enable_2fa_success'),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              webShowClose: true,
              webPosition: "center",
              webBgColor: toHex(Colors.green),
              fontSize: 16.0);
          dispatch(NavigateAction.pop());
          return state.copy(
              accountUserState: state.accountUserState
                  .copy(user: state.accountUserState.user.copy(otp: true)));
        }
      }
      return null;
    }
  }
}
