import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'package:mobidax_redux/account/account_actions.dart';
import 'package:mobidax_redux/enable_2fa/enable_2fa_actions.dart';
import '../store.dart';

class Enable2FAPageModel extends BaseModel<AppState> {
  Enable2FAPageModel({
    this.secret,
    this.enabled2FA,
    this.accountError,
    this.userName,
  });

  final String secret;
  final bool enabled2FA;
  final OperationException accountError;
  final String userName;

  VoidCallback clearError;

  Function(String code) onVerifyOTP;

  Enable2FAPageModel.build({
    this.onVerifyOTP,
    this.secret,
    this.enabled2FA,
    this.accountError,
    this.clearError,
    this.userName,
  }) : super(equals: [secret, enabled2FA, accountError]);

  @override
  Enable2FAPageModel fromStore() => Enable2FAPageModel.build(
      onVerifyOTP: (String code) {
        dispatch(Manage2FA(code: code));
      },
      secret: state.enable2faPageState.secret,
      enabled2FA: state.accountUserState.user.otp,
      accountError: state.accountUserState.error,
      clearError: () {
        dispatch(ClearAccountErrorAction());
      },
      userName: state.accountUserState.user.email);
}
