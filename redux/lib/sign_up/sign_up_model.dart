import 'dart:ui';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'package:mobidax_redux/redux.dart';
import 'sign_up_actions.dart';
import '../store.dart';

class SignUpPageModel extends BaseModel<AppState> {
  final OperationException error;
  final bool signUpLoading;
  final bool isAuthorized;

  SignUpPageModel({this.error, this.isAuthorized, this.signUpLoading});

  Function(String, String, String) onCreateUser;
  Function clearError;
  VoidCallback onSignUpLoading;

  SignUpPageModel.build({
    this.signUpLoading,
    this.clearError,
    this.isAuthorized,
    this.onSignUpLoading,
    this.onCreateUser,
    this.error,
  }) : super(equals: [error, isAuthorized, signUpLoading]);

  @override
  SignUpPageModel fromStore() => SignUpPageModel.build(
      onSignUpLoading: () {
        dispatch(SignUpLoadingAction());
      },
      onCreateUser: (String email, String pass, String referral) {
        dispatch(
            CreateUserAction(email: email, pass: pass, referralCode: referral));
      },
      clearError: () {
        dispatch(ClearErrorAction());
      },
      signUpLoading: state.signUpPageState.signUpLoading,
      error: state.signUpPageState.error);
}
