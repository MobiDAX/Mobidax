import 'package:async_redux/async_redux.dart';
import 'package:graphql/client.dart';
import 'package:mobidax_redux/account/account_actions.dart';
import '../store.dart';
import '../graphql_client.dart';

class CreateUserAction extends ReduxAction<AppState> {
  final String email;
  final String pass;
  final String referralCode;
  final OperationException error;

  CreateUserAction({this.email, this.pass, this.referralCode = "", this.error});

  static const signUpMutation = r'''
            mutation SignUp($email: String!, $password: String!, $refid: String ){
              createUser(email: $email, password: $password, refid: $refid ){
                data
              }
            }
        ''';

  @override
  Future<AppState> reduce() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(signUpMutation),
      variables: <String, dynamic>{
        'email': email,
        'password': pass,
        'refid': referralCode != "" ? referralCode : null
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);
    if (result.hasException) {
      return state.copy(
          signUpPageState: state.signUpPageState
              .copy(signUpLoading: false, error: result.exception));
    } else {
      return null;
    }
  }

  @override
  void after() {
    if (state.signUpPageState.error == null) {
      dispatch(AskEmailConfirmationAction(email: email));
      dispatch(NavigateAction.pushReplacementNamed('/emailConfirmation',
          arguments: {"email": email}));
    }
  }
}

class SignUpLoadingAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print("Loading Sign Up");
    return state.copy(
      signUpPageState: state.signUpPageState.copy(signUpLoading: true),
    );
  }
}
