import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobidax_redux/redux.dart';
import '../account/account_state.dart';
import '../funds/funds_actions.dart';
import '../store.dart';

class FundsPageModel extends BaseModel<AppState> {
  final bool isAuthorized;
  List<UserBalanceItemState> balances;
  final bool isFundsLoading;
  final int selectedCardIndex;
  final List<DepositItem> deposits;
  final List<WithdrawalItem> withdrawals;
  final List<Beneficiary> beneficiaries;
  final Beneficiary selectedBeneficiary;
  final UserState user;

  FundsPageModel(
      {this.isAuthorized,
      this.isFundsLoading,
      this.selectedCardIndex,
      this.withdrawals,
      this.beneficiaries,
      this.selectedBeneficiary,
      this.user,
      this.deposits});

  VoidCallback onFetchBalance;
  Function(int id, String currency) onShowWallet;

  FundsPageModel.build(
      {this.isAuthorized,
      this.onFetchBalance,
      this.balances,
      this.deposits,
      this.withdrawals,
      this.beneficiaries,
      this.user,
      this.selectedBeneficiary,
      this.selectedCardIndex,
      this.isFundsLoading,
      this.onShowWallet})
      : super(equals: [
          isAuthorized,
          balances,
          deposits,
          withdrawals,
          selectedCardIndex,
          user,
          beneficiaries,
          selectedBeneficiary,
          isFundsLoading,
        ]);

  @override
  FundsPageModel fromStore() => FundsPageModel.build(
        isAuthorized: state.accountUserState.isAuthourized,
        balances: state.accountUserState.balances,
        deposits: state.fundsPageState.deposits,
        withdrawals: state.fundsPageState.withdrawals,
        selectedBeneficiary: state.walletPageState.selectedBeneficiary,
        selectedCardIndex: state.walletPageState.selectedCardIndex,
        beneficiaries: state.accountUserState.beneficiaries,
        user: state.accountUserState.user,
        onFetchBalance: () {
          dispatch(FetchBalance());
          dispatch(GetDepositHistory());
          dispatch(GetWithdrawalHistory());
        },
        onShowWallet: (int id, String currency) {
          dispatch(WalletSelectCardAction(id: id));
          dispatch(GetDepositAddress(currency: currency));
        },
        isFundsLoading: state.fundsPageState.isFundsLoading,
      );
}
