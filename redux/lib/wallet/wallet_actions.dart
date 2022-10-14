import 'package:async_redux/async_redux.dart';
import 'package:mobidax_redux/account/account_state.dart';
import 'package:mobidax_redux/account/account_actions.dart';
import 'package:mobidax_redux/funds/funds_actions.dart';
import 'package:mobidax_redux/helper/validate_session.dart';
import '../account/account_state.dart';
import '../store.dart';

class WalletTabAction extends ReduxAction<AppState> {
  final int id;

  WalletTabAction({this.id});

  @override
  Future<AppState> reduce() async {
    if (validateSession(
        state.accountUserState.userSession.barongSessionExpires)) {
      if (state.accountUserState.userSession.barongSessionExpires != '')
        dispatch(DestroySessionAction());
      return null;
    } else {
      return state.copy(
          walletPageState: state.walletPageState.copy(selectedTabIndex: id),
          withdrawalHistoryPageState:
              state.withdrawalHistoryPageState.copy(isLoading: true),
          depositHistoryPageState:
              state.depositHistoryPageState.copy(isLoading: true));
    }
  }
}

class WalletSelectCardAction extends ReduxAction<AppState> {
  final int id;

  WalletSelectCardAction({this.id});

  @override
  void after() {
    // TODO: implement after
    dispatch(ResetSelectedBeneficiaryAction());
    dispatch(GetDepositHistory());
    dispatch(GetWithdrawalHistory());
  }

  @override
  Future<AppState> reduce() async {
    if (validateSession(
        state.accountUserState.userSession.barongSessionExpires)) {
      if (state.accountUserState.userSession.barongSessionExpires != '')
        dispatch(DestroySessionAction());
      return null;
    } else {
      return state.copy(
          walletPageState: state.walletPageState.copy(selectedCardIndex: id),
          withdrawalHistoryPageState:
              state.withdrawalHistoryPageState.copy(isLoading: true),
          depositHistoryPageState:
              state.depositHistoryPageState.copy(isLoading: true));
    }
  }
}

class SelectBeneficiaryAction extends ReduxAction<AppState> {
  final Beneficiary beneficiary;

  SelectBeneficiaryAction({this.beneficiary});

  @override
  Future<AppState> reduce() async {
    dispatch(NavigateAction.pop());
    return state.copy(
        walletPageState:
            state.walletPageState.copy(selectedBeneficiary: beneficiary));
  }
}

class ResetSelectedBeneficiaryAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    return state.copy(
        walletPageState: state.walletPageState.copy(selectedBeneficiary: null));
  }
}
