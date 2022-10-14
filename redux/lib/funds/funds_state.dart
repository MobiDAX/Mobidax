import 'package:json_annotation/json_annotation.dart';

part 'funds_state.g.dart';

@JsonSerializable(nullable: false)
class FundsPageState {
  final bool isFundsLoading;
  final List<WithdrawalItem> withdrawals;
  final List<DepositItem> deposits;

  FundsPageState({this.isFundsLoading, this.withdrawals, this.deposits});

  FundsPageState copy({isFundsLoading, withdrawals, deposits}) =>
      FundsPageState(
          isFundsLoading: isFundsLoading ?? this.isFundsLoading,
          withdrawals: withdrawals ?? this.withdrawals,
          deposits: deposits ?? this.deposits);

  static FundsPageState initialState() =>
      FundsPageState(isFundsLoading: false, withdrawals: [], deposits: []);

  factory FundsPageState.fromJson(Map<String, dynamic> json) =>
      _$FundsPageStateFromJson(json);

  Map<String, dynamic> toJson() => _$FundsPageStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FundsPageState &&
          runtimeType == other.runtimeType &&
          isFundsLoading == other.isFundsLoading &&
          withdrawals == other.withdrawals &&
          deposits == other.deposits;

  @override
  int get hashCode =>
      isFundsLoading.hashCode ^ withdrawals.hashCode ^ deposits.hashCode;
}

@JsonSerializable(nullable: false)
class DepositItem {
  final String id;
  final String currency;
  final double amount;
  final double fee;
  @JsonKey(name: 'txid')
  final String blockchainTXID;
  final String state;
  final int confirmations;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'completed_at')
  final String completedAt;

  DepositItem(
      {this.id,
      this.currency,
      this.amount,
      this.fee,
      this.blockchainTXID,
      this.state,
      this.confirmations,
      this.createdAt,
      this.completedAt});

  DepositItem copy(id, currency, fee, amount, blockchainTXID, state,
          confirmations, createdAt, completedAt) =>
      DepositItem(
          id: id ?? this.id,
          currency: currency ?? this.currency,
          amount: amount ?? this.amount,
          fee: fee ?? this.fee,
          blockchainTXID: blockchainTXID ?? this.blockchainTXID,
          state: state ?? this.state,
          confirmations: confirmations ?? this.confirmations,
          createdAt: createdAt ?? this.createdAt,
          completedAt: completedAt ?? this.completedAt);

  static DepositItem initialState() => DepositItem(
      id: '',
      currency: "",
      amount: 0,
      fee: 0,
      blockchainTXID: "",
      state: "",
      confirmations: 0,
      createdAt: "",
      completedAt: "");

  factory DepositItem.fromJson(Map<String, dynamic> json) =>
      _$DepositItemFromJson(json);

  Map<String, dynamic> toJson() => _$DepositItemToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepositItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          currency == other.currency &&
          amount == other.amount &&
          fee == other.fee &&
          blockchainTXID == other.blockchainTXID &&
          state == other.state &&
          confirmations == other.confirmations &&
          createdAt == other.createdAt &&
          completedAt == other.completedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      currency.hashCode ^
      amount.hashCode ^
      fee.hashCode ^
      blockchainTXID.hashCode ^
      state.hashCode ^
      confirmations.hashCode ^
      createdAt.hashCode ^
      completedAt.hashCode;
}

@JsonSerializable(nullable: false)
class WithdrawalItem {
  final int id;
  final String currency;
  final String type;
  final double amount;
  final double fee;
  @JsonKey(name: 'blockchain_txid')
  final String blockchainTXID;
  final String rid;
  final String state;
  final int confirmations;
  final String note;
  @JsonKey(name: 'created_at')
  final int createdAt;
  @JsonKey(name: 'updated_at')
  final int updatedAt;
  @JsonKey(name: 'done_at')
  final int doneAt;

  WithdrawalItem(
      {this.id,
      this.currency,
      this.type,
      this.amount,
      this.fee,
      this.blockchainTXID,
      this.rid,
      this.state,
      this.confirmations,
      this.note,
      this.createdAt,
      this.updatedAt,
      this.doneAt});

  WithdrawalItem copy(id, currency, type, fee, amount, blockchainTXID, rid,
          state, confirmations, note, createdAt, updatedAt, doneAt) =>
      WithdrawalItem(
          id: id ?? this.id,
          currency: currency ?? this.currency,
          type: type ?? this.type,
          amount: amount ?? this.amount,
          fee: fee ?? this.fee,
          blockchainTXID: blockchainTXID ?? this.blockchainTXID,
          rid: rid ?? this.rid,
          state: state ?? this.state,
          confirmations: confirmations ?? this.confirmations,
          note: note ?? this.note,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
          doneAt: doneAt ?? this.doneAt);

  static WithdrawalItem initialState() => WithdrawalItem(
      id: 0,
      currency: "",
      type: "",
      amount: 0,
      fee: 0,
      blockchainTXID: "",
      rid: "",
      state: "",
      confirmations: 0,
      note: "",
      createdAt: 0,
      updatedAt: 0,
      doneAt: 0);

  factory WithdrawalItem.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalItemFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalItemToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithdrawalItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          currency == other.currency &&
          type == other.type &&
          amount == other.amount &&
          fee == other.fee &&
          blockchainTXID == other.blockchainTXID &&
          rid == other.rid &&
          state == other.state &&
          confirmations == other.confirmations &&
          note == other.note &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          doneAt == other.doneAt;

  @override
  int get hashCode =>
      id.hashCode ^
      currency.hashCode ^
      type.hashCode ^
      amount.hashCode ^
      fee.hashCode ^
      blockchainTXID.hashCode ^
      rid.hashCode ^
      state.hashCode ^
      confirmations.hashCode ^
      note.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      doneAt.hashCode;
}
