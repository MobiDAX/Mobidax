import 'dart:ui';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'sign_in_actions.dart';
import '../store.dart';

class SignInPageModel extends BaseModel<AppState> {
  final bool signInLoading;
  final bool isAuthorized;
  final bool enabled2FA;
  final OperationException error;

  SignInPageModel(
      {this.signInLoading, this.isAuthorized, this.error, this.enabled2FA});

  Function(String, String, String) onAuthenticate;
  Function clearError;
  VoidCallback onSignInLoading;

  SignInPageModel.build(
      {this.onAuthenticate,
      this.signInLoading,
      this.clearError,
      this.onSignInLoading,
      this.isAuthorized,
      this.error,
      this.enabled2FA})
      : super(equals: [signInLoading, isAuthorized, error, enabled2FA]);

  @override
  SignInPageModel fromStore() => SignInPageModel.build(
      onSignInLoading: () {
        dispatch(SignInLoadingAction());
      },
      onAuthenticate: (String email, String pass, String code) async {
        await dispatchFuture(
            AuthenticateAction(email: email, pass: pass, code: code));
      },
      clearError: () {
        dispatch(ClearErrorAction());
      },
      signInLoading: state.signInPageState.signInLoading,
      isAuthorized: state.accountUserState.isAuthourized,
      error: state.signInPageState.error,
      enabled2FA: state.signInPageState.enabled2FA);
}
