// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) {
  return AppState(
    homePageState:
        HomePageState.fromJson(json['homePageState'] as Map<String, dynamic>),
    marketsPageState: MarketsPageState.fromJson(
        json['marketsPageState'] as Map<String, dynamic>),
    exchangePageState: ExchangePageState.fromJson(
        json['exchangePageState'] as Map<String, dynamic>),
    signInPageState: SignInPageState.fromJson(
        json['signInPageState'] as Map<String, dynamic>),
    accountUserState: AccountUserState.fromJson(
        json['accountUserState'] as Map<String, dynamic>),
    fundsPageState:
        FundsPageState.fromJson(json['fundsPageState'] as Map<String, dynamic>),
    signUpPageState: SignUpPageState.fromJson(
        json['signUpPageState'] as Map<String, dynamic>),
    enable2faPageState: Enable2FAPageState.fromJson(
        json['enable2faPageState'] as Map<String, dynamic>),
    walletPageState: WalletPageState.fromJson(
        json['walletPageState'] as Map<String, dynamic>),
    createBeneficiaryPageState: CreateBeneficiaryPageState.fromJson(
        json['createBeneficiaryPageState'] as Map<String, dynamic>),
    confirmBeneficiaryPageState: ConfirmBeneficiaryPageState.fromJson(
        json['confirmBeneficiaryPageState'] as Map<String, dynamic>),
    withdrawalPageState: WithdrawalPageState.fromJson(
        json['withdrawalPageState'] as Map<String, dynamic>),
    withdrawalHistoryPageState: WithdrawalHistoryPageState.fromJson(
        json['withdrawalHistoryPageState'] as Map<String, dynamic>),
    depositHistoryPageState: DepositHistoryPageState.fromJson(
        json['depositHistoryPageState'] as Map<String, dynamic>),
    aunthenteqEnabled: json['aunthenteqEnabled'] as bool,
    accountActivitiesPageState: AccountActivitiesPageState.fromJson(
        json['accountActivitiesPageState'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'homePageState': instance.homePageState,
      'marketsPageState': instance.marketsPageState,
      'exchangePageState': instance.exchangePageState,
      'signInPageState': instance.signInPageState,
      'accountUserState': instance.accountUserState,
      'fundsPageState': instance.fundsPageState,
      'signUpPageState': instance.signUpPageState,
      'enable2faPageState': instance.enable2faPageState,
      'walletPageState': instance.walletPageState,
      'withdrawalPageState': instance.withdrawalPageState,
      'createBeneficiaryPageState': instance.createBeneficiaryPageState,
      'confirmBeneficiaryPageState': instance.confirmBeneficiaryPageState,
      'withdrawalHistoryPageState': instance.withdrawalHistoryPageState,
      'depositHistoryPageState': instance.depositHistoryPageState,
      'accountActivitiesPageState': instance.accountActivitiesPageState,
      'aunthenteqEnabled': instance.aunthenteqEnabled,
    };
