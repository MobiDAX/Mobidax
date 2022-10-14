// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_beneficiary_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmBeneficiaryPageState _$ConfirmBeneficiaryPageStateFromJson(
    Map<String, dynamic> json) {
  return ConfirmBeneficiaryPageState(
    createdBeneficiary: json['createdBeneficiary'] == null
        ? null
        : Beneficiary.fromJson(
            json['createdBeneficiary'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ConfirmBeneficiaryPageStateToJson(
        ConfirmBeneficiaryPageState instance) =>
    <String, dynamic>{
      'createdBeneficiary': instance.createdBeneficiary,
    };
