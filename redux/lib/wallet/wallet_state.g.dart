// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletPageState _$WalletPageStateFromJson(Map<String, dynamic> json) {
  return WalletPageState(
    selectedTabIndex: json['selectedTabIndex'] as int,
    selectedCardIndex: json['selectedCardIndex'] as int,
    selectedBeneficiary: json['selectedBeneficiary'] == null
        ? null
        : Beneficiary.fromJson(
            json['selectedBeneficiary'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WalletPageStateToJson(WalletPageState instance) =>
    <String, dynamic>{
      'selectedTabIndex': instance.selectedTabIndex,
      'selectedCardIndex': instance.selectedCardIndex,
      'selectedBeneficiary': instance.selectedBeneficiary,
    };
