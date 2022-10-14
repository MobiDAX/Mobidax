import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobidax_redux/exchange/exchange_state.dart';
import 'package:mobidax_redux/home/home_actions.dart';
import 'account_actions.dart';
import 'account_state.dart';
import '../store.dart';

class AccountPageModel extends BaseModel<AppState> {
  final bool isAuthorized;
  final bool homeVisited;
  final UserState user;
  final int selectedIndex;
  final OperationException error;
  final String success;
  final List<UserActivity> activities;
  final List<TradeItem> trades;
  final List<OrderItem> orders;
  final bool authenteqEnabled;
  final List<ApiKey> userApiKeys;

  int id;

  AccountPageModel(
      {this.isAuthorized,
      this.homeVisited,
      this.user,
      this.selectedIndex,
      this.error,
      this.success,
      this.orders,
      this.authenteqEnabled,
      this.activities,
      this.trades,
      this.userApiKeys});

  VoidCallback onGetStarted;
  VoidCallback onClickOrderHistory;
  VoidCallback onClickTradeHistory;
  VoidCallback onClickActivities;
  VoidCallback onVerifyEmail;
  VoidCallback clearError;
  VoidCallback onVerifyIdentity;
  VoidCallback onFetchOrderHistory;
  VoidCallback onFetchActivityHistory;
  VoidCallback onEnable2FA;
  VoidCallback getTradeHistory;
  VoidCallback onLogOut;
  VoidCallback getAuthenteqUrl;
  Function(String) onEmailConfirmation;
  Function(String) onResendEmailConfirmation;
  Function(String, String, String) onResetPassword;
  Function(String, String, String, String, String, String, String)
      onUpdateProfile;
  Function(String, String) onVerifyPhone;
  Function(String) onAskPasswordReset;
  Function(String, VoidCallback) onAddPhone;
  Function onUploadDoc;
  Function(int) onTabSelect;
  Function(String oldPassword, String newPassword, String confirmPassword)
      onChangePassword;
  Function(String otp, Function callback) onCreateApiKey;
  Function(String otp, String kid, bool enabled) onUpdateApiKey;
  Function(String otp, String kid) onDeleteApiKey;

  AccountPageModel.build(
      {this.isAuthorized,
      this.homeVisited,
      this.user,
      this.orders,
      this.selectedIndex,
      this.error,
      this.success,
      this.trades,
      this.authenteqEnabled,
      this.activities,
      this.onAskPasswordReset,
      this.onResetPassword,
      this.onClickOrderHistory,
      this.onClickTradeHistory,
      this.onClickActivities,
      this.onChangePassword,
      this.userApiKeys,
      this.onCreateApiKey,
      this.onUpdateApiKey,
      this.onDeleteApiKey,
      this.onFetchOrderHistory,
      this.onFetchActivityHistory,
      this.onEnable2FA,
      this.onEmailConfirmation,
      this.onGetStarted,
      this.onUploadDoc,
      this.onAddPhone,
      this.onVerifyPhone,
      this.onResendEmailConfirmation,
      this.onUpdateProfile,
      this.getAuthenteqUrl,
      this.getTradeHistory,
      this.onVerifyEmail,
      this.clearError,
      this.onVerifyIdentity,
      this.onLogOut,
      this.onTabSelect})
      : super(equals: [
          isAuthorized,
          user,
          selectedIndex,
          homeVisited,
          error,
          success,
          orders,
          userApiKeys,
          authenteqEnabled,
          trades
        ]);

  @override
  AccountPageModel fromStore() => AccountPageModel.build(
      onClickOrderHistory: () {
        dispatch(NavigateAction.pushNamed('/accountOrderHistory'));
      },
      onClickTradeHistory: () {
        dispatch(NavigateAction.pushNamed('/accountTradeHistory'));
      },
      getTradeHistory: () {
        dispatch(FetchTradeHistoryAction());
      },
      onClickActivities: () {
        dispatch(NavigateAction.pushNamed('/accountActivities'));
      },
      clearError: () {
        dispatch(ClearAccountErrorAction());
      },
      getAuthenteqUrl: () {
        dispatch(AunthenteqGetUrl());
      },
      onVerifyEmail: () {
        print("Pressed verify email button");
      },
      onVerifyPhone: (number, code) {
        dispatch(VerifyPhoneAction(number: number, code: code));
      },
      onAddPhone: (number, callback) async {
        await dispatchFuture(AddPhoneAction(number: number));
        callback();
      },
      onUpdateProfile: (_firstName, _lastName, _dateOfBirth,
          _countryOfResidence, _city, _address, _postcode) {
        dispatch(UpdateProfileAction(
            firstName: _firstName,
            lastName: _lastName,
            dateOfBirth: _dateOfBirth,
            country: _countryOfResidence,
            city: _city,
            address: _address,
            postcode: _postcode));
      },
      onAskPasswordReset: (str) {
        dispatch(AskPasswordResetAction(email: str));
      },
      onResetPassword: (password, confirmPassword, token) {
        dispatch(PasswordResetAction(
            confirmPassword: confirmPassword,
            password: password,
            token: token));
      },
      onUploadDoc: (String docType, String docNumber, String docExpire,
          List<PickedFile> upload, VoidCallback callback) async {
        await dispatchFuture(UploadDocAction(
            docType: docType,
            docNumber: docNumber,
            docExpire: docExpire,
            docs: upload));
        callback();
      },
      onVerifyIdentity: () {
        dispatch(NavigateAction.pushNamed('/accountVerifyIdentity'));
      },
      onEnable2FA: () {
        dispatch(NavigateAction.pushNamed('/accountEnable2FA',
            arguments: {'enabled2FA': state.accountUserState.user.otp}));
      },
      onChangePassword:
          (String oldPassword, String newPassword, String confirmPassword) {
        dispatch(ChangePasswordAction(
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword));
      },
      userApiKeys: state.accountUserState.userApiKey,
      onCreateApiKey: (String otp, Function callback) {
        dispatch(CreateApiKey(otp: otp, callback: callback));
      },
      onUpdateApiKey: (String otp, String kid, bool enabled) {
        dispatch(UpdateApiKey(otp: otp, kid: kid, enabled: enabled));
      },
      onDeleteApiKey: (String otp, String kid) {
        dispatch(DeleteApiKey(otp: otp, kid: kid));
      },
      onLogOut: () {
        dispatch(DestroySessionAction());
      },
      onFetchOrderHistory: () {
        dispatch(OrdersHistoryFetchAction());
      },
      onFetchActivityHistory: () {
        dispatch(FetchAccountActivities());
      },
      onResendEmailConfirmation: (String email) {
        dispatch(AskEmailConfirmationAction(email: email));
      },
      onTabSelect: (int id) {
        dispatch(SelectTabAction(id: id));
      },
      onEmailConfirmation: (String token) {
        dispatch(ConfirmEmailAction(token: token));
      },
      onGetStarted: () {
        dispatch(HomeVisitedAction());
      },
      authenteqEnabled: state.aunthenteqEnabled,
      homeVisited: state.homePageState.homeVisited,
      trades: state.accountUserState.tradeHistory,
      isAuthorized: state.accountUserState.isAuthourized,
      user: state.accountUserState.user,
      error: state.accountUserState.error,
      success: state.accountUserState.success,
      orders: state.accountUserState.ordersHistory,
      activities: state.accountUserState.activities,
      selectedIndex: state.accountUserState.selectedIndex);
}
