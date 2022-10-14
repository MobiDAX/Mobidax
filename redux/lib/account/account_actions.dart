import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:async_redux/async_redux.dart';
import 'package:graphql/client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobidax_redux/account/account_state.dart';
import 'package:mobidax_redux/exchange/exchange_state.dart';
import 'package:mobidax_redux/funds/funds_state.dart';
import 'package:mobidax_redux/graphql_client.dart';
import 'package:mobidax_redux/helper/validate_session.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:http_parser/http_parser.dart';
import '../helpers.dart';
import '../redux.dart';
import '../store.dart';
import 'package:universal_html/html.dart' as html;

class SelectTabAction extends ReduxAction<AppState> {
  final int id;

  SelectTabAction({this.id});

  @override
  Future<AppState> reduce() async {
    if (validateSession(
        state.accountUserState.userSession.barongSessionExpires)) {
      if (state.accountUserState.userSession.barongSessionExpires != '')
        dispatch(DestroySessionAction());
      return null;
    } else {
      return state.copy(
          accountUserState: state.accountUserState.copy(selectedIndex: id));
    }
  }
}

class DestroySessionAction extends ReduxAction<AppState> {
  static const logoutUser = r'''
              mutation logout($_barong_session: String!){
                logout(_barong_session: $_barong_session){
                  data
                }
              }
        ''';

  @override
  void after() {
    dispatch(PersistAction());
    super.after();
  }

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(logoutUser),
      variables: <String, dynamic>{
        '_barong_session': state.accountUserState.userSession.barongSession
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      if (sessionInvalidException(result.exception)) {
        return state.copy(
          accountUserState: state.accountUserState.copy(
              isAuthourized: false,
              userSession: UserSessionState.initialState(),
              user: UserState.initialState()),
          fundsPageState: FundsPageState.initialState(),
          signInPageState: SignInPageState.initialState(),
          signUpPageState: SignUpPageState.initialState(),
          enable2faPageState: Enable2FAPageState.initialState(),
        );
      }
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    }

    Fluttertoast.showToast(
        msg: tr('session_expired'),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        webShowClose: true,
        webPosition: "center",
        webBgColor: toHex(Colors.red),
        fontSize: 16.0);

    return state.copy(
      accountUserState: state.accountUserState.copy(
          isAuthourized: false,
          userSession: UserSessionState.initialState(),
          user: UserState.initialState()),
      fundsPageState: FundsPageState.initialState(),
      signInPageState: SignInPageState.initialState(),
      signUpPageState: SignUpPageState.initialState(),
      enable2faPageState: Enable2FAPageState.initialState(),
    );
  }
}

class UpdateUserProfile extends ReduxAction<AppState> {
  String session;
  static const getUser = r'''
          query user($_barong_session: String!) {
            userWithProfile(_barong_session: $_barong_session) {
              uid
              email
              role
              level
              otp
              state
              referral_uid
              labels {
                key
                value
                scope
              }
              _barong_session
              _barong_session_expires
              data
              created_at
              updated_at
              phones {
                country
                number
                validated_at
              }
              profile {
                first_name
                last_name
                dob
                address
                postcode
                city
                country
                state
                metadata
              }
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
      final QueryOptions options = QueryOptions(
        documentNode: gql(getUser),
        variables: <String, dynamic>{'_barong_session': session},
      );
      final QueryResult result = await GraphQLClientAPI.client().query(options);
      if (result.hasException) {
        if (result.exception.toString().contains('authz.invalid_session'))
          dispatch(DestroySessionAction());
        return state.copy(
            exchangePageState:
                state.exchangePageState.copy(error: result.exception));
      } else {
        var user = UserState.fromJson(result.data['userWithProfile']);
        return state.copy(
            accountUserState: state.accountUserState.copy(user: user),
            enable2faPageState: state.enable2faPageState.copy(secret: ''));
      }
    }
  }
}

class ClearAccountErrorAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return state.copy(
        accountUserState:
            state.accountUserState.copy(error: null, success: null));
  }
}

class ClearStateAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return state.copy(
        signInPageState: state.signInPageState
            .copy(signInLoading: false, error: null, enabled2FA: false),
        signUpPageState:
            state.signUpPageState.copy(signUpLoading: false, error: null));
  }
}

class GetDepositAddress extends ReduxAction<AppState> {
  final String currency;

  static const getDepositAddressQuery = r'''
          query getDepositAddress($_barong_session: String!, $currency: String!) {
            getDepositAddress(_barong_session: $_barong_session, currency: $currency) {
              currency
              address
            }
          }
        ''';

  GetDepositAddress({this.currency});

  @override
  Future<AppState> reduce() async {
    var session = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(getDepositAddressQuery),
      variables: <String, dynamic>{
        '_barong_session': session,
        'currency': currency
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      var address = result.data['getDepositAddress']['address'];
      List<UserBalanceItemState> balances =
          List.from(state.accountUserState.balances);
      var balance =
          balances.firstWhere((element) => element.currency.id == currency);
      var index =
          balances.indexWhere((element) => element.currency.id == currency);
      var cur = balance.currency.copy(depositAddress: address);
      var b = balance.copy(currency: cur);
      balances.removeWhere((element) => element.currency.id == currency);
      balances.insert(index, b);
      return state.copy(
          accountUserState: state.accountUserState.copy(balances: balances));
    }
  }
}

class GetBeneficiaries extends ReduxAction<AppState> {
  static const getDepositAddressQuery = r'''
          query getBeneficiaries($_barong_session: String!) {
            getBeneficiaries(_barong_session: $_barong_session) {
                  id
                  name
                  address
                  name
                  state
                  description
                  currency
            }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    var session = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(getDepositAddressQuery),
      variables: <String, dynamic>{
        '_barong_session': session,
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          walletPageState: state.walletPageState.copy(error: result.exception));
    } else {
      var beneficiaries = result.data['getBeneficiaries'];
      List<Beneficiary> res = [];
      beneficiaries.forEach((b) => res.add(Beneficiary.fromJson(b)));
      return state.copy(
          accountUserState: state.accountUserState.copy(beneficiaries: res));
    }
  }
}

class ChangePasswordAction extends ReduxAction<AppState> {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordAction(
      {this.oldPassword, this.newPassword, this.confirmPassword});

  static const changePasswordMutation = r'''
          mutation changePassword($_barong_session: String!, $old_password: String!, $new_password: String!, $confirm_password: String! ) {
            changePassword(_barong_session: $_barong_session,old_password:$old_password, new_password: $new_password, confirm_password: $confirm_password){
              data
                          }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    var session = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(changePasswordMutation),
      variables: <String, dynamic>{
        '_barong_session': session,
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    }

    if (result.data['changePassword']['data'] == 'ok') {
      dispatch(NavigateAction.pop());
    }

    return state.copy(
        accountUserState: state.accountUserState
            .copy(success: tr('success.password.changed.successfuly')));
  }
}

class FetchTradeHistoryAction extends ReduxAction<AppState> {
  static const getTradeHistoryQuery = r'''
  query getTradeHistory($_barong_session: String!){
  getTradeHistory(_barong_session: $_barong_session){
  trades{
  id
  marketName
  side
  price
  total
  amount
  created_at
  side
  taker_type
  }
  page
  total
  perPage
  }
  }
  ''';

  @override
  Future<AppState> reduce() async {
    var session = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(getTradeHistoryQuery),
      variables: <String, dynamic>{'_barong_session': session},
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);
    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      List<TradeItem> trades = [];

      result.data['getTradeHistory']['trades']
          .forEach((trade) => trades.add(TradeItem.fromJson(trade)));

      return state.copy(
          accountUserState: state.accountUserState.copy(
        tradeHistory: trades,
      ));
    }
  }
}

class OrdersHistoryFetchAction extends ReduxAction<AppState> {
  static const OrdersHistoryFetchQuery = r'''
  query getOrderHistory($_barong_session: String!){
  getOrderHistory(_barong_session: $_barong_session){
  orders{
  id
  market
  marketName
  kind
  side
  ord_type
  price
  avg_price
  state
  origin_volume
  remaining_volume
  executed_volume
  at
  created_at
  updated_at
  trades_count
  }
  page
  total
  perPage
  }
  }
  ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(OrdersHistoryFetchQuery),
      variables: <String, dynamic>{
        '_barong_session': state.accountUserState.userSession.barongSession,
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      List<OrderItem> res = [];

      result.data['getOrderHistory']['orders'].forEach((k) {
        res.add(OrderItem.fromJson(k));
      });

      return state.copy(
          accountUserState: state.accountUserState.copy(
        ordersHistory: res,
      ));
    }
  }
}

class FetchAccountActivities extends ReduxAction<AppState> {
  String session;
  static const getUserActivities = r'''
  query get_activities($_barong_session: String!) {
  getActivityHistory(_barong_session: $_barong_session, topic: ALL, limit: 20, page: 0) {
  activities {
  id
  user_id
  target_uid
  category
  user_ip
  user_agent
  topic
  action
  result
  data
  created_at
  }
  }
  }
  ''';

  @override
  Future<AppState> reduce() async {
    session = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(getUserActivities),
      variables: <String, dynamic>{
        '_barong_session': session,
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);
    if (result.hasException) {
      return state.copy(
          accountActivitiesPageState: state.accountActivitiesPageState.copy(
        isLoading: result.loading,
      ));
    } else {
      var activities = (result.data['getActivityHistory']['activities'] as List)
          .map((item) => UserActivity.fromJson(item))
          .toList();
      return state.copy(
          accountUserState: state.accountUserState.copy(
            activities: activities,
          ),
          accountActivitiesPageState:
              state.accountActivitiesPageState.copy(isLoading: result.loading));
    }
  }
}

class PushAccountStatusAction extends ReduxAction<AppState> {
  PushAccountStatusAction({this.error, this.success});

  final Exception error;
  final String success;

  @override
  AppState reduce() {
    return state.copy(
        accountUserState:
            state.accountUserState.copy(error: error, success: success));
  }
}

class AskEmailConfirmationAction extends ReduxAction<AppState> {
  AskEmailConfirmationAction({this.email});

  final String email;

  static const changePasswordMutation = r'''
          mutation($email: String!, $lang: String) {
            askEmailConfirm (email: $email, lang: $lang){
              data
            }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(changePasswordMutation),
      variables: <String, dynamic>{
        'email': email,
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      if (result.data['askEmailConfirm']['data'] == 'ok') {
        Fluttertoast.showToast(
            msg: "${tr('email_sent')} $email",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            webShowClose: true,
            webPosition: 'center',
            webBgColor: toHex(Colors.green),
            fontSize: 16.0);
        return null;
      }
    }

    return null;
  }
}

class ConfirmEmailAction extends ReduxAction<AppState> {
  final String token;

  ConfirmEmailAction({this.token});

  static const confirmEmailMutation = r'''
          mutation($token: String!, $lang: String) {
            emailConfirm(token: $token, lang: $lang){
              data
            }
          }
        ''';

  @override
  void after() {
    // TODO: implement after
    super.after();
  }

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(confirmEmailMutation),
      variables: <String, dynamic>{
        'token': token,
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      if (result.data['emailConfirm']['data'] == 'ok') {
        Fluttertoast.showToast(
            msg: tr('email_confirmation_success'),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            webShowClose: true,
            webPosition: 'center',
            webBgColor: toHex(Colors.green),
            fontSize: 16.0);
        dispatch(NavigateAction.pushReplacementNamed('/signInPage'));
        return null;
      }
    }

    return null;
  }
}

class AskPasswordResetAction extends ReduxAction<AppState> {
  final String email;

  AskPasswordResetAction({this.email});

  static const askResetPasswordMutation = r'''
          mutation($email: String!, $lang: String) {
            askResetPassword (email: $email, lang: $lang){
              data
            }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(askResetPasswordMutation),
      variables: <String, dynamic>{
        'email': email,
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      if (result.data['askResetPassword']['data'] == 'ok') {
        Fluttertoast.showToast(
            msg: tr('success.password.forgot'),
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
      }
    }

    return null;
  }
}

class PasswordResetAction extends ReduxAction<AppState> {
  final String password;
  final String confirmPassword;
  final String token;

  PasswordResetAction({this.confirmPassword, this.password, this.token});

  static const askResetPasswordMutation = r'''
          mutation($password: String!, $reset_password_token: String!, $confirm_password: String! $lang: String) {
              resetPassword(password: $password, reset_password_token: $reset_password_token, confirm_password: $confirm_password, lang: $lang){
                data
              }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(askResetPasswordMutation),
      variables: <String, dynamic>{
        'password': password,
        'confirm_password': confirmPassword,
        'reset_password_token': token,
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      if (result.data['resetPassword']['data'] == 'ok') {
        Fluttertoast.showToast(
            msg: tr('password_reset_success'),
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
      }
    }

    return null;
  }
}

class AddPhoneAction extends ReduxAction<AppState> {
  final String number;

  AddPhoneAction({this.number});

  static const addPhoneMutation = r'''
          mutation($phone_number: String!, $_barong_session: String!) {
            addPhone(phone_number: $phone_number, _barong_session: $_barong_session){
              data
            }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(addPhoneMutation),
      variables: <String, dynamic>{
        'phone_number': number,
        '_barong_session': state.accountUserState.userSession.barongSession
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      if (result.exception.graphqlErrors.first.message
          .contains('resource.phone.exists')) {
        dispatch(AskPhoneCodeAction(number: number));
        dispatch(
            NavigateAction.pushNamed('/accountVerifyPhone', arguments: number));
        return null;
      }
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      if (result.data['addPhone']['data'] == 'ok') {
        dispatch(
            NavigateAction.pushNamed('/accountVerifyPhone', arguments: number));
      }
    }

    return null;
  }
}

class VerifyPhoneAction extends ReduxAction<AppState> {
  final String number;
  final String code;

  VerifyPhoneAction({this.number, this.code});

  static const verifyPhoneMutation = r'''
          mutation($phone_number: String!, $_barong_session: String!, $verification_code: String!) {
            verifyPhone(phone_number: $phone_number, _barong_session: $_barong_session, verification_code: $verification_code){
              data
            }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(verifyPhoneMutation),
      variables: <String, dynamic>{
        'phone_number': number,
        'verification_code': code,
        '_barong_session': state.accountUserState.userSession.barongSession
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      if (result.data['verifyPhone']['data'] == 'ok') {
        Fluttertoast.showToast(
            msg: "$number  ${tr('phone_verification_success')}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            webShowClose: true,
            webPosition: "center",
            webBgColor: toHex(Colors.green),
            fontSize: 16.0);
        dispatch(NavigateAction.pushReplacementNamed('/'));
      }
    }

    return null;
  }

  @override
  void after() {
    // TODO: implement after
    dispatch(UpdateUserProfile());
    dispatch(NavigateAction.pushNamedAndRemoveAll('/',
        arguments: {"_currentTab": '/account'}));
    super.after();
  }
}

class AskPhoneCodeAction extends ReduxAction<AppState> {
  final String number;

  AskPhoneCodeAction({this.number});

  static const AskPhoneCodeMutation = r'''
          mutation($phone_number: String!, $_barong_session: String!) {
            askPhoneCode(phone_number: $phone_number, _barong_session: $_barong_session){
              data
            }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(AskPhoneCodeMutation),
      variables: <String, dynamic>{
        'phone_number': number,
        '_barong_session': state.accountUserState.userSession.barongSession
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    }

    return null;
  }
}

class UpdateProfileAction extends ReduxAction<AppState> {
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String country;
  final String city;
  final String address;
  final String postcode;

  UpdateProfileAction(
      {this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.country,
      this.city,
      this.address,
      this.postcode});

  static const updateProfileMutation = r'''
          mutation($_barong_session: String!,$first_name: String,$last_name: String,$dateOfBirth: String,$address: String,$postcode: String,$city: String,$country: String,$metadata: String) {
              saveProfile(_barong_session: $_barong_session, first_name: $first_name, last_name: $last_name, dateOfBirth: $dateOfBirth,address: $address, postcode: $postcode,city: $city,country: $country,metadata: $metadata  ){
                     first_name
                     last_name
                     dob
                     address
                     postcode
                     city
                     country
                     state
                     metadata
              }

          }
        ''';

  @override
  void after() {
    // TODO: implement after
    dispatch(UpdateUserProfile());
    super.after();
  }

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(updateProfileMutation),
      variables: <String, dynamic>{
        '_barong_session': state.accountUserState.userSession.barongSession,
        'first_name': firstName,
        'last_name': lastName,
        'dateOfBirth': dateOfBirth,
        'address': address,
        'postcode': postcode,
        'city': city,
        'country': country,
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      var profile = UserProfile.fromJson(result.data['saveProfile']);

      Fluttertoast.showToast(
          msg: tr('profile_submitted'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: "center",
          webBgColor: toHex(Colors.green),
          fontSize: 16.0);

      state.aunthenteqEnabled
          ? dispatch(
              NavigateAction.pushReplacementNamed('/authenteqVerification'))
          : dispatch(
              NavigateAction.pushReplacementNamed('/accountVerifyDocuments'));

      return state.copy(
          accountUserState: state.accountUserState
              .copy(user: state.accountUserState.user.copy(profile: profile)));
    }
  }
}

class UploadDocAction extends ReduxAction<AppState> {
  final List<PickedFile> docs;
  final String docType;
  final String docNumber;
  final String docExpire;

  UploadDocAction({this.docs, this.docType, this.docNumber, this.docExpire});

  static const UploadDocMutation = r'''
          mutation($doc_type: String!,$doc_number: String!,$doc_expire: String!,$upload: Upload!, $_barong_session: String!) {
            uploadKYCDocument(doc_type: $doc_type,doc_number: $doc_number,doc_expire: $doc_expire,upload: $upload, _barong_session: $_barong_session){
              data
            }      
          }
        ''';

  @override
  void after() {
    // TODO: implement after
    dispatch(UpdateUserProfile());
    dispatch(NavigateAction.pushNamedAndRemoveAll('/',
        arguments: {"_currentTab": '/account'}));
    super.after();
  }

  @override
  Future<AppState> reduce() async {
    for (var _doc in docs) {
      var byteData = await _doc.readAsBytes();

      var multipartFile = MultipartFile.fromBytes('photo', byteData,
          filename: kIsWeb
              ? _doc.path.split('/').last + "." + 'png'
              : _doc.path.split('/').last,
          contentType: MediaType("image",
              kIsWeb ? 'png' : _doc.path.split('/').last.split('.').last));

      final QueryOptions options = QueryOptions(
        documentNode: gql(UploadDocMutation),
        variables: <String, dynamic>{
          'doc_type': docType,
          'doc_number': docNumber,
          'doc_expire': docExpire,
          'upload': multipartFile,
          '_barong_session': state.accountUserState.userSession.barongSession
        },
      );

      final QueryResult result = await GraphQLClientAPI.client().query(options);

      if (result.hasException) {
        if (result.exception.toString().contains('authz.invalid_session'))
          dispatch(DestroySessionAction());
        return state.copy(
            accountUserState:
                state.accountUserState.copy(error: result.exception));
      }
    }

    Fluttertoast.showToast(
        msg: tr('documents_submitted'),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        webShowClose: true,
        webPosition: "center",
        webBgColor: toHex(Colors.green),
        fontSize: 16.0);
    // dispatch(NavigateAction.pop());

    return null;
  }
}

class UserApiKeys extends ReduxAction<AppState> {
  static const UserApiKeysQuery = r'''
  query getUserApiKeys($_barong_session: String!){
    getUserApiKeys(_barong_session: $_barong_session){
      kid
      algorithm
      scope
      enabled
      secret
    }
  }
  ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(UserApiKeysQuery),
      variables: <String, dynamic>{
        '_barong_session': state.accountUserState.userSession.barongSession,
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);
    List<ApiKey> res = [];
    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      result.data['getUserApiKeys'].forEach((k) {
        res.add(ApiKey.fromJson(k));
      });
    }

    return state.copy(
        accountUserState: state.accountUserState.copy(
      userApiKey: res,
    ));
  }
}

class CreateApiKey extends ReduxAction<AppState> {
  final String otp;
  final Function(String kid, String secret) callback;

  CreateApiKey({this.otp, this.callback});

  static const createApiKeyMutation = r'''
          mutation createApiKey($_barong_session: String!, $otp: String! ) {
            createApiKey(_barong_session: $_barong_session, otp: $otp){
              kid
              algorithm
              scope
              enabled
              secret
            }
          }
        ''';

  @override
  Future<AppState> reduce() async {
    var session = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(createApiKeyMutation),
      variables: <String, dynamic>{
        '_barong_session': session,
        'otp': otp,
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);
    List<ApiKey> res = List.from(state.accountUserState.userApiKey);

    if (result.hasException) {
      Fluttertoast.showToast(
          msg: "${tr('resource.api_key.invalid_otp')}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: "center",
          webBgColor: toHex(Colors.red),
          fontSize: 16.0);
    }

    if (result.data['createApiKey'] != null) {
      result.data['createApiKey']['createApiKey'] = true;
      var key = ApiKey.fromJson(result.data['createApiKey']);
      res.add(key);

      Fluttertoast.showToast(
          msg: "${tr('toast.create.api_keys')}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: "center",
          webBgColor: toHex(Colors.green),
          fontSize: 16.0);

      callback(key.kid, key.secret);
    }

    return state.copy(
        accountUserState: state.accountUserState.copy(userApiKey: res));
  }
}

class UpdateApiKey extends ReduxAction<AppState> {
  final String otp;
  final String kid;
  final bool enabled;

  UpdateApiKey({this.otp, this.kid, this.enabled});

  static const updateApiKeyMutation = r'''
          mutation updateApiKey(
           $_barong_session: String!,
           $otp: String!,
           $kid: String!,
           $enabled: Boolean!
          ) {
            updateApiKey(
            _barong_session: $_barong_session,
            otp: $otp,
            kid: $kid,
            enabled: $enabled
          ){
              data
            }
          }
      ''';

  @override
  void after() {
    dispatch(NavigateAction.pop());
    super.after();
  }

  @override
  Future<AppState> reduce() async {
    var session = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(updateApiKeyMutation),
      variables: <String, dynamic>{
        '_barong_session': session,
        'otp': otp,
        'kid': kid,
        'enabled': enabled
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      Fluttertoast.showToast(
          msg: "${tr('resource.api_key.invalid_otp')}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: "center",
          webBgColor: toHex(Colors.red),
          fontSize: 16.0);
    }

    if (result.data['updateApiKey']['data'] == 'ok') {
      dispatch(UserApiKeys());

      Fluttertoast.showToast(
          msg: "${tr('toast.update.api_keys')}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: "center",
          webBgColor: toHex(Colors.green),
          fontSize: 16.0);
    }
    return null;
  }
}

class DeleteApiKey extends ReduxAction<AppState> {
  final String otp;
  final String kid;

  DeleteApiKey({this.otp, this.kid});

  static const deleteApiKeyMutation = r'''
          mutation deleteApiKey(
           $_barong_session: String!,
           $otp: String!,
           $kid: String!,
          ) {
            deleteApiKey(
            _barong_session: $_barong_session,
            otp: $otp,
            kid: $kid,
          ){
              data
            }
          }
      ''';
  @override
  void after() {
    dispatch(NavigateAction.pop());
    super.after();
  }

  @override
  Future<AppState> reduce() async {
    var session = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(deleteApiKeyMutation),
      variables: <String, dynamic>{
        '_barong_session': session,
        'otp': otp,
        'kid': kid,
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);
    List<ApiKey> res = List.from(state.accountUserState.userApiKey);

    if (result.hasException) {
      Fluttertoast.showToast(
          msg: "${tr('resource.api_key.invalid_otp')}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: "center",
          webBgColor: toHex(Colors.red),
          fontSize: 16.0);
    }

    if (result.data['deleteApiKey']['data'] == 'ok') {
      res.removeWhere((element) => element.kid == kid);

      Fluttertoast.showToast(
          msg: "${tr('toast.delete.api_keys')}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: "center",
          webBgColor: toHex(Colors.green),
          fontSize: 16.0);
    }

    return state.copy(
        accountUserState: state.accountUserState.copy(userApiKey: res));
  }
}

class FetchAuthenteqConfig extends ReduxAction<AppState> {
  static const fetchAuthenteqConfig = r'''
    query {
      authenteqEnabled
    }
  ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(fetchAuthenteqConfig),
    );

    try {
      final QueryResult result = await GraphQLClientAPI.client().query(options);
      if (result.hasException) {
        return state.copy(aunthenteqEnabled: false);
      }

      return state.copy(aunthenteqEnabled: result.data['authenteqEnabled']);
    } on Exception catch (_) {
      return state.copy(aunthenteqEnabled: false);
    }
  }
}

class AunthenteqGetUrl extends ReduxAction<AppState> {
  static const AuthenteqGetUrlMutation = r'''
          mutation($_barong_session: String!){
            authenteqGetUrl( _barong_session: $_barong_session)
          }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(AuthenteqGetUrlMutation),
      variables: <String, dynamic>{
        '_barong_session': state.accountUserState.userSession.barongSession
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      if (kIsWeb) {
        html.window.open(result.data['authenteqGetUrl'], 'new tab');
      }
    }

    return null;
  }
}

class AuthenteqVericationAction extends ReduxAction<AppState> {
  final String code;

  AuthenteqVericationAction({this.code});

  static const AuthenteqGetUrlMutation = r'''
          mutation($_barong_session: String!, $code: String!, $uid: String!){
            authenteqVerify( _barong_session: $_barong_session, code: $code, uid: $uid)
          }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(AuthenteqGetUrlMutation),
      variables: <String, dynamic>{
        '_barong_session': state.accountUserState.userSession.barongSession,
        'uid': state.accountUserState.user.uid,
        'code': code
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);

    if (result.hasException) {
      return state.copy(
          accountUserState:
              state.accountUserState.copy(error: result.exception));
    } else {
      dispatch(NavigateAction.pop());

      if (result.data['authenteqVerify'] == "verified") {
        Fluttertoast.showToast(
            msg: "${tr('authenteq_verification_success')}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            webShowClose: true,
            webPosition: "center",
            webBgColor: toHex(Colors.green),
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "${tr('authenteq_verification_failure')}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            webShowClose: true,
            webPosition: "center",
            webBgColor: toHex(Colors.red),
            fontSize: 16.0);
      }
    }

    return null;
  }
}
