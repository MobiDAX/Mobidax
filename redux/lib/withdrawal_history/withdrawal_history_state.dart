import 'package:json_annotation/json_annotation.dart';

part 'withdrawal_history_state.g.dart';

@JsonSerializable(nullable: false)
class WithdrawalHistoryPageState {
  final bool isLoading;

  WithdrawalHistoryPageState({this.isLoading});

  WithdrawalHistoryPageState copy({bool isLoading}) =>
      WithdrawalHistoryPageState(isLoading: isLoading ?? this.isLoading);

  static WithdrawalHistoryPageState initialState() =>
      WithdrawalHistoryPageState(isLoading: true);

  factory WithdrawalHistoryPageState.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalHistoryPageStateFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalHistoryPageStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithdrawalHistoryPageState &&
          runtimeType == other.runtimeType &&
          other.isLoading;

  @override
  int get hashCode => isLoading.hashCode;
}
