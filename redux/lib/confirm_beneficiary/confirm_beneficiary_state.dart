import 'package:json_annotation/json_annotation.dart';
import 'package:mobidax_redux/account/account_state.dart';

part 'confirm_beneficiary_state.g.dart';

@JsonSerializable(nullable: true)
class ConfirmBeneficiaryPageState {
  @JsonKey(ignore: true)
  final Exception error;
  final Beneficiary createdBeneficiary;
  ConfirmBeneficiaryPageState({this.error, this.createdBeneficiary});

  ConfirmBeneficiaryPageState copy({error, createdBeneficiary}) =>
      ConfirmBeneficiaryPageState(
          error: error,
          createdBeneficiary: createdBeneficiary ?? this.createdBeneficiary);

  static ConfirmBeneficiaryPageState initialState() =>
      ConfirmBeneficiaryPageState(
          error: null, createdBeneficiary: Beneficiary.initialState());

  factory ConfirmBeneficiaryPageState.fromJson(Map<String, dynamic> json) =>
      _$ConfirmBeneficiaryPageStateFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmBeneficiaryPageStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfirmBeneficiaryPageState &&
          runtimeType == other.runtimeType &&
          createdBeneficiary == other.createdBeneficiary &&
          error == other.error;

  @override
  int get hashCode;
}
