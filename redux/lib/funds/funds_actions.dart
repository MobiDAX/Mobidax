import 'package:async_redux/async_redux.dart';
import 'package:graphql/client.dart';
import 'package:mobidax_redux/account/account_actions.dart';
import 'package:mobidax_redux/helper/validate_session.dart';
import '../account/account_state.dart';
import '../store.dart';
import '../graphql_client.dart';
import 'funds_state.dart';

class FetchBalance extends ReduxAction<AppState> {
  String barongSession;

  static const fetchBalanceQuery = r'''
            query balance($_barong_session: String!){
              balances(_barong_session: $_barong_session){
                currency{
                 name,
                  id,
                  symbol,
                  type,
                  position,
                  precision,
                  explorer_address,
                  explorer_transaction,
                  withdrawal_enabled,
                  deposit_enabled,
                  withdraw_fee,
                  min_withdraw_amount,
                  icon_url
                }
                balance,
                locked
              }
            }
        ''';

  @override
  void after() {
    // TODO: implement after
    dispatch(FundsLoadingAction(isLoading: false));
    super.after();
  }

  @override
  void before() {
    // TODO: implement after
    dispatch(FundsLoadingAction(isLoading: true));
    super.after();
  }

  @override
  Future<AppState> reduce() async {
    if (validateSession(
        state.accountUserState.userSession.barongSessionExpires)) {
      if (state.accountUserState.userSession.barongSessionExpires != '')
        dispatch(DestroySessionAction());
      return null;
    } else {
      barongSession = state.accountUserState.userSession.barongSession;
      final QueryOptions options = QueryOptions(
        documentNode: gql(fetchBalanceQuery),
        variables: <String, dynamic>{
          '_barong_session': barongSession,
        },
      );

      final QueryResult result = await GraphQLClientAPI.client().query(options);

      if (result.hasException) {
        if (result.exception.toString().contains('authz.invalid_session'))
          dispatch(DestroySessionAction());
        return state.copy(
            fundsPageState: state.fundsPageState.copy(
          isFundsLoading: result.loading,
        ));
      } else {
        var inState = List.from(state.accountUserState.balances);
        var res;
        res = (result.data['balances']).map<UserBalanceItemState>((item) {
          return UserBalanceItemState(
              currency: CurrencyItemState.fromJson(item['currency']).copy(
                  depositAddress: inState
                      .firstWhere(
                          (element) =>
                              element.currency.id == item['currency']['id'],
                          orElse: () {
                        return UserBalanceItemState.initialState();
                      })
                      .currency
                      .depositAddress),
              locked: item['locked'].toDouble(),
              balance: item['balance'].toDouble());
        }).toList();

        return state.copy(
          fundsPageState: state.fundsPageState.copy(isFundsLoading: false),
          accountUserState: state.accountUserState.copy(balances: res),
        );
      }
    }
  }
}

class GetWithdrawalHistory extends ReduxAction<AppState> {
  String session;
  static const getUserWithdrawal = r'''
              query withdrawals($_barong_session: String!, $currency: String!) {
                getWithdrawHistory(_barong_session: $_barong_session, currency: $currency) {
                  page
                  withdraws {
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
              }
        ''';

  @override
  Future<AppState> reduce() async {
    int index = state.walletPageState.selectedCardIndex;
    String currency = state.accountUserState.balances[index].currency.id;
    session = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(getUserWithdrawal),
      variables: <String, dynamic>{
        '_barong_session': session,
        'currency': currency
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);
    if (result.hasException) {
      return null;
    } else {
      var withdrawals = (result.data['getWithdrawHistory']['withdraws'] as List)
          .map((item) => WithdrawalItem.fromJson(item))
          .toList();
      return state.copy(
          fundsPageState: state.fundsPageState.copy(withdrawals: withdrawals),
          withdrawalHistoryPageState:
              state.withdrawalHistoryPageState.copy(isLoading: false));
    }
  }
}

class GetDepositHistory extends ReduxAction<AppState> {
  String session;
  static const getUserWithdrawal = r'''
              query deposits($_barong_session: String!, $currency: String!) {
                getDepositHistory(_barong_session: $_barong_session, currency: $currency) {
                  page
                  deposits {
                    id
                    currency
                    amount
                    fee
                    txid
                    state
                    confirmations
                    created_at
                    completed_at
                  }
                }
              }
        ''';

  @override
  Future<AppState> reduce() async {
    int index = state.walletPageState.selectedCardIndex;
    String currency = state.accountUserState.balances[index].currency.id;
    session = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(getUserWithdrawal),
      variables: <String, dynamic>{
        '_barong_session': session,
        'currency': currency
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);
    if (result.hasException) {
      return null;
    } else {
      var deposits = (result.data['getDepositHistory']['deposits'] as List)
          .map((item) => DepositItem.fromJson(item))
          .toList();
      return state.copy(
          fundsPageState: state.fundsPageState.copy(deposits: deposits),
          depositHistoryPageState:
              state.depositHistoryPageState.copy(isLoading: false));
    }
  }
}

class FundsLoadingAction extends ReduxAction<AppState> {
  final bool isLoading;

  FundsLoadingAction({this.isLoading});

  @override
  AppState reduce() {
    return state.copy(
        fundsPageState: state.fundsPageState.copy(isFundsLoading: isLoading));
  }
}
