import 'package:json_annotation/json_annotation.dart';

part 'deposit_history_state.g.dart';

@JsonSerializable(nullable: false)
class DepositHistoryPageState {
  final bool isLoading;

  DepositHistoryPageState({this.isLoading});

  DepositHistoryPageState copy({bool isLoading}) =>
      DepositHistoryPageState(isLoading: isLoading ?? this.isLoading);

  static DepositHistoryPageState initialState() =>
      DepositHistoryPageState(isLoading: true);

  factory DepositHistoryPageState.fromJson(Map<String, dynamic> json) =>
      _$DepositHistoryPageStateFromJson(json);

  Map<String, dynamic> toJson() => _$DepositHistoryPageStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepositHistoryPageState &&
          runtimeType == other.runtimeType &&
          other.isLoading;

  @override
  int get hashCode => isLoading.hashCode;
}
