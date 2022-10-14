import 'package:json_annotation/json_annotation.dart';

part 'create_beneficiary_state.g.dart';

@JsonSerializable(nullable: false)
class CreateBeneficiaryPageState {
  @JsonKey(ignore: true)
  final Exception error;
  final bool loading;

  CreateBeneficiaryPageState({this.error, this.loading});

  CreateBeneficiaryPageState copy({Exception error, bool loading}) =>
      CreateBeneficiaryPageState(
          error: error, loading: loading ?? this.loading);

  static CreateBeneficiaryPageState initialState() =>
      CreateBeneficiaryPageState(error: null, loading: false);

  factory CreateBeneficiaryPageState.fromJson(Map<String, dynamic> json) =>
      _$CreateBeneficiaryPageStateFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBeneficiaryPageStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateBeneficiaryPageState &&
          runtimeType == other.runtimeType &&
          loading == other.loading &&
          error == other.error;

  @override
  int get hashCode => loading.hashCode ^ error.hashCode;
}
