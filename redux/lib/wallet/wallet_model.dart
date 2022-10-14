import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'package:mobidax_redux/redux.dart';
import '../account/account_state.dart';
import '../store.dart';

class WalletPageModel extends BaseModel<AppState> {
  final int selectedTabIndex;
  final int selectedCardIndex;
  final OperationException error;
  final UserState user;
  final Beneficiary selectedBeneficiary;

  List<UserBalanceItemState> balances;
  List<Beneficiary> beneficiaries;
  WalletPageModel(
      {this.selectedTabIndex,
      this.selectedCardIndex,
      this.beneficiaries,
      this.user,
      this.selectedBeneficiary,
      this.error});

  Function(int id) onTabSelect;
  Function onFetchBeneficiary;
  Function(Beneficiary beneficiary) onBeneficiarySelect;
  Function(int id, String currency) onCardSelect;
  VoidCallback onWithdrawal;
  VoidCallback onAddBeneficiary;
  VoidCallback onWithdrawalHistory;
  VoidCallback onDepositHistory;
  VoidCallback clearError;
  Function(int id) onDeleteBeneficiary;

  WalletPageModel.build(
      {this.selectedTabIndex,
      this.selectedCardIndex,
      this.onTabSelect,
      this.onCardSelect,
      this.onWithdrawal,
      this.balances,
      this.clearError,
      this.error,
      this.user,
      this.beneficiaries,
      this.selectedBeneficiary,
      this.onFetchBeneficiary,
      this.onAddBeneficiary,
      this.onBeneficiarySelect,
      this.onDepositHistory,
      this.onWithdrawalHistory,
      this.onDeleteBeneficiary})
      : super(equals: [
          selectedTabIndex,
          balances,
          beneficiaries,
          user,
          error,
          selectedCardIndex,
          selectedBeneficiary,
          error
        ]);

  @override
  WalletPageModel fromStore() => WalletPageModel.build(
      selectedTabIndex: state.walletPageState.selectedTabIndex,
      onTabSelect: (int id) {
        dispatch(WalletTabAction(id: id));
      },
      balances: state.accountUserState.balances,
      error: state.walletPageState.error,
      onWithdrawal: () {
        dispatch(NavigateAction.pushNamed("/withdrawal"));
      },
      onAddBeneficiary: () {
        dispatch(NavigateAction.pushNamed("/createBeneficiary"));
      },
      onBeneficiarySelect: (Beneficiary beneficiary) {
        dispatch(SelectBeneficiaryAction(beneficiary: beneficiary));
      },
      onDepositHistory: () {
        dispatch(NavigateAction.pushNamed("/depositHistory"));
      },
      onWithdrawalHistory: () {
        dispatch(NavigateAction.pushNamed("/withdrawalHistory"));
      },
      clearError: () {
        dispatch(ClearAccountErrorAction());
      },
      onFetchBeneficiary: () {
        dispatch(GetBeneficiaries());
      },
      onDeleteBeneficiary: (int id) {
        dispatch(DeleteBeneficiary(id: id));
      },
      user: state.accountUserState.user,
      selectedBeneficiary: state.walletPageState.selectedBeneficiary,
      selectedCardIndex: state.walletPageState.selectedCardIndex,
      beneficiaries: state.accountUserState.beneficiaries,
      onCardSelect: (int id, String currency) {
        dispatch(WalletSelectCardAction(id: id));
        dispatch(GetDepositAddress(currency: currency));
      });
}
