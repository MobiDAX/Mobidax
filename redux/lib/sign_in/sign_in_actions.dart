import 'package:async_redux/async_redux.dart';
import 'package:graphql/client.dart';
import 'package:mobidax_redux/account/account_actions.dart';
import 'package:mobidax_redux/exchange/exchange_actions.dart';
import 'package:mobidax_redux/home/home_actions.dart';
import '../account/account_state.dart';
import '../funds/funds_actions.dart';
import '../store.dart';
import '../graphql_client.dart';

class AuthenticateAction extends ReduxAction<AppState> {
  final String email;
  final String pass;
  final String code;

  AuthenticateAction({this.email, this.pass, this.code = ''});

  ///TO DO: Add label

  static const signInQuery = r'''
                mutation SignIn($email:String!, $password: String!, $otp_code: String) {
                  login(email: $email, password: $password, otp_code: $otp_code) {
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
    final QueryOptions options = QueryOptions(
      documentNode: gql(signInQuery),
      variables: <String, dynamic>{
        'email': email,
        'password': pass,
        'otp_code': code
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);
    if (result.hasException) {
      if (code == '') {
        if (!result.exception
                .toString()
                .contains('identity.session.invalid_otp') &&
            !result.exception
                .toString()
                .contains('identity.session.missing_otp')) {
          return state.copy(
              accountUserState:
                  state.accountUserState.copy(isAuthourized: false),
              signInPageState: state.signInPageState
                  .copy(signInLoading: false, error: result.exception));
        } else {
          return state.copy(
              accountUserState:
                  state.accountUserState.copy(isAuthourized: false),
              signInPageState: state.signInPageState
                  .copy(signInLoading: false, error: null, enabled2FA: true));
        }
      } else {
        return state.copy(
            accountUserState: state.accountUserState.copy(isAuthourized: false),
            signInPageState: state.signInPageState
                .copy(signInLoading: false, error: result.exception));
      }
    } else {
      var res = UserSessionState.fromJson(result.data['login']);
      var user = UserState.fromJson(result.data['login']);
      if (result.data['login']['labels'].length == 0) {
        dispatch(NavigateAction.pushReplacementNamed('/emailConfirmation',
            arguments: {"email": email}));
        return state.copy(
            signInPageState: state.signInPageState.copy(
          signInLoading: false,
        ));
      }

      return state.copy(
          accountUserState: state.accountUserState
              .copy(userSession: res, isAuthourized: true, user: user),
          signInPageState: state.signInPageState.copy(error: null));
    }
  }

  @override
  void after() {
    if (state.accountUserState.isAuthourized) {
      dispatch(HomeVisitedAction());
      dispatch(FetchBalance());
      dispatch(GetBeneficiaries());
      dispatch(FetchTradeHistoryAction());
      dispatch(OrdersHistoryFetchAction());
      dispatch(FetchAccountActivities());
      dispatch(UserTradeFetchAction(
          selectedMarketId: state.marketsPageState.marketItems
              .firstWhere((element) => element.selected == true)
              .id,
          barongSession: state.accountUserState.userSession.barongSession));
      dispatch(UserOrdersFetchAction(
          selectedMarketId: state.marketsPageState.marketItems
              .firstWhere((element) => element.selected == true)
              .id,
          barongSession: state.accountUserState.userSession.barongSession));
      dispatch(UserTradeSubAction(
          selectedMarketId: state.marketsPageState.marketItems
              .firstWhere((element) => element.selected == true)
              .id,
          barongSession: state.accountUserState.userSession.barongSession));
      dispatch(UserOrderSubAction(
          selectedMarketId: state.marketsPageState.marketItems
              .firstWhere((element) => element.selected == true)
              .id,
          barongSession: state.accountUserState.userSession.barongSession));
      dispatch(NavigateAction.pushNamedAndRemoveAll('/',
          arguments: {"_currentTab": '/funds'}));
    }
  }
}

class SignInLoadingAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    return state.copy(
      signInPageState: state.signInPageState.copy(signInLoading: true),
    );
  }
}

class ClearErrorAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return state.copy(
        signInPageState: state.signInPageState.copy(error: null),
        signUpPageState: state.signUpPageState.copy(error: null));
  }
}
