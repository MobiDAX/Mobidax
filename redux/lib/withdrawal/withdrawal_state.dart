import 'package:json_annotation/json_annotation.dart';

part 'withdrawal_state.g.dart';

@JsonSerializable(nullable: true)
class WithdrawalPageState {
  @JsonKey(ignore: true)
  final Exception error;
  WithdrawalPageState({this.error});

  WithdrawalPageState copy({Exception error}) =>
      WithdrawalPageState(error: error);

  static WithdrawalPageState initialState() => WithdrawalPageState(error: null);

  factory WithdrawalPageState.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalPageStateFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalPageStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithdrawalPageState &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode;
}
