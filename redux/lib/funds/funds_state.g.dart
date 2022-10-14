// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'funds_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FundsPageState _$FundsPageStateFromJson(Map<String, dynamic> json) {
  return FundsPageState(
    isFundsLoading: json['isFundsLoading'] as bool,
    withdrawals: (json['withdrawals'] as List)
        .map((e) => WithdrawalItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    deposits: (json['deposits'] as List)
        .map((e) => DepositItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$FundsPageStateToJson(FundsPageState instance) =>
    <String, dynamic>{
      'isFundsLoading': instance.isFundsLoading,
      'withdrawals': instance.withdrawals,
      'deposits': instance.deposits,
    };

DepositItem _$DepositItemFromJson(Map<String, dynamic> json) {
  return DepositItem(
    id: json['id'] as String,
    currency: json['currency'] as String,
    amount: (json['amount'] as num).toDouble(),
    fee: (json['fee'] as num).toDouble(),
    blockchainTXID: json['txid'] as String,
    state: json['state'] as String,
    confirmations: json['confirmations'] as int,
    createdAt: json['created_at'] as String,
    completedAt: json['completed_at'] as String,
  );
}

Map<String, dynamic> _$DepositItemToJson(DepositItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'currency': instance.currency,
      'amount': instance.amount,
      'fee': instance.fee,
      'txid': instance.blockchainTXID,
      'state': instance.state,
      'confirmations': instance.confirmations,
      'created_at': instance.createdAt,
      'completed_at': instance.completedAt,
    };

WithdrawalItem _$WithdrawalItemFromJson(Map<String, dynamic> json) {
  return WithdrawalItem(
    id: json['id'] as int,
    currency: json['currency'] as String,
    type: json['type'] as String,
    amount: (json['amount'] as num).toDouble(),
    fee: (json['fee'] as num).toDouble(),
    blockchainTXID: json['blockchain_txid'] as String,
    rid: json['rid'] as String,
    state: json['state'] as String,
    confirmations: json['confirmations'] as int,
    note: json['note'] as String,
    createdAt: json['created_at'] as int,
    updatedAt: json['updated_at'] as int,
    doneAt: json['done_at'] as int,
  );
}

Map<String, dynamic> _$WithdrawalItemToJson(WithdrawalItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'currency': instance.currency,
      'type': instance.type,
      'amount': instance.amount,
      'fee': instance.fee,
      'blockchain_txid': instance.blockchainTXID,
      'rid': instance.rid,
      'state': instance.state,
      'confirmations': instance.confirmations,
      'note': instance.note,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'done_at': instance.doneAt,
    };
