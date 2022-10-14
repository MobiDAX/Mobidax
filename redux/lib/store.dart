import 'package:mobidax_redux/redux.dart';
import 'account/account_state.dart';
import 'account_activities/account_activities_state.dart';
import 'funds/funds_state.dart';
import 'markets/markets_state.dart';
import 'exchange/exchange_state.dart';
import 'home/home_state.dart';
import 'package:json_annotation/json_annotation.dart';
import 'sign_in/sign_in_state.dart';
import 'sign_up/sign_up_state.dart';
import 'enable_2fa/enable_2fa_state.dart';

part 'store.g.dart';

@JsonSerializable(nullable: false)
class AppState {
  final HomePageState homePageState;
  final MarketsPageState marketsPageState;
  final ExchangePageState exchangePageState;
  final SignInPageState signInPageState;
  final AccountUserState accountUserState;
  final FundsPageState fundsPageState;
  final SignUpPageState signUpPageState;
  final Enable2FAPageState enable2faPageState;
  final WalletPageState walletPageState;
  final WithdrawalPageState withdrawalPageState;
  final CreateBeneficiaryPageState createBeneficiaryPageState;
  final ConfirmBeneficiaryPageState confirmBeneficiaryPageState;
  final WithdrawalHistoryPageState withdrawalHistoryPageState;
  final DepositHistoryPageState depositHistoryPageState;
  final AccountActivitiesPageState accountActivitiesPageState;
  final bool aunthenteqEnabled;

  AppState(
      {this.homePageState,
      this.marketsPageState,
      this.exchangePageState,
      this.signInPageState,
      this.accountUserState,
      this.fundsPageState,
      this.signUpPageState,
      this.enable2faPageState,
      this.walletPageState,
      this.createBeneficiaryPageState,
      this.confirmBeneficiaryPageState,
      this.withdrawalPageState,
      this.withdrawalHistoryPageState,
      this.depositHistoryPageState,
      this.aunthenteqEnabled,
      this.accountActivitiesPageState});

  AppState copy(
          {HomePageState homePageState,
          MarketsPageState marketsPageState,
          ExchangePageState exchangePageState,
          SignInPageState signInPageState,
          AccountUserState accountUserState,
          FundsPageState fundsPageState,
          SignUpPageState signUpPageState,
          Enable2FAPageState enable2faPageState,
          WalletPageState walletPageState,
          CreateBeneficiaryPageState createBeneficiaryPageState,
          ConfirmBeneficiaryPageState confirmBeneficiaryPageState,
          WithdrawalPageState withdrawalPageState,
          WithdrawalHistoryPageState withdrawalHistoryPageState,
          DepositHistoryPageState depositHistoryPageState,
          bool aunthenteqEnabled,
          AccountActivitiesPageState accountActivitiesPageState}) =>
      AppState(
          homePageState: homePageState ?? this.homePageState,
          marketsPageState: marketsPageState ?? this.marketsPageState,
          exchangePageState: exchangePageState ?? this.exchangePageState,
          signInPageState: signInPageState ?? this.signInPageState,
          accountUserState: accountUserState ?? this.accountUserState,
          fundsPageState: fundsPageState ?? this.fundsPageState,
          signUpPageState: signUpPageState ?? this.signUpPageState,
          enable2faPageState: enable2faPageState ?? this.enable2faPageState,
          walletPageState: walletPageState ?? this.walletPageState,
          createBeneficiaryPageState:
              createBeneficiaryPageState ?? this.createBeneficiaryPageState,
          confirmBeneficiaryPageState:
              confirmBeneficiaryPageState ?? this.confirmBeneficiaryPageState,
          withdrawalPageState: withdrawalPageState ?? this.withdrawalPageState,
          depositHistoryPageState:
              depositHistoryPageState ?? this.depositHistoryPageState,
          withdrawalHistoryPageState:
              withdrawalHistoryPageState ?? this.withdrawalHistoryPageState,
          aunthenteqEnabled: aunthenteqEnabled ?? this.aunthenteqEnabled,
          accountActivitiesPageState:
              accountActivitiesPageState ?? this.accountActivitiesPageState);

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  static AppState initialState() => AppState(
        homePageState: HomePageState.initialState(),
        marketsPageState: MarketsPageState.initialState(),
        exchangePageState: ExchangePageState.initialState(),
        signInPageState: SignInPageState.initialState(),
        accountUserState: AccountUserState.initialState(),
        fundsPageState: FundsPageState.initialState(),
        signUpPageState: SignUpPageState.initialState(),
        enable2faPageState: Enable2FAPageState.initialState(),
        walletPageState: WalletPageState.initialState(),
        createBeneficiaryPageState: CreateBeneficiaryPageState.initialState(),
        confirmBeneficiaryPageState: ConfirmBeneficiaryPageState.initialState(),
        withdrawalPageState: WithdrawalPageState.initialState(),
        withdrawalHistoryPageState: WithdrawalHistoryPageState.initialState(),
        depositHistoryPageState: DepositHistoryPageState.initialState(),
        aunthenteqEnabled: false,
        accountActivitiesPageState: AccountActivitiesPageState.initialState(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          homePageState == other.homePageState &&
          marketsPageState == other.marketsPageState &&
          exchangePageState == other.exchangePageState &&
          signInPageState == other.signInPageState &&
          signUpPageState == other.signUpPageState &&
          fundsPageState == other.fundsPageState &&
          enable2faPageState == other.enable2faPageState &&
          walletPageState == other.walletPageState &&
          createBeneficiaryPageState == other.createBeneficiaryPageState &&
          confirmBeneficiaryPageState == other.confirmBeneficiaryPageState &&
          withdrawalPageState == other.withdrawalPageState &&
          withdrawalHistoryPageState == other.withdrawalHistoryPageState &&
          depositHistoryPageState == other.depositHistoryPageState &&
          aunthenteqEnabled == other.aunthenteqEnabled &&
          accountActivitiesPageState == other.accountActivitiesPageState;

  @override
  int get hashCode =>
      homePageState.hashCode ^
      marketsPageState.hashCode ^
      exchangePageState.hashCode ^
      signInPageState.hashCode ^
      signUpPageState.hashCode ^
      fundsPageState.hashCode ^
      enable2faPageState.hashCode ^
      walletPageState.hashCode ^
      createBeneficiaryPageState.hashCode ^
      confirmBeneficiaryPageState.hashCode ^
      withdrawalPageState.hashCode ^
      withdrawalHistoryPageState.hashCode ^
      depositHistoryPageState.hashCode ^
      aunthenteqEnabled.hashCode ^
      accountActivitiesPageState.hashCode;
}
