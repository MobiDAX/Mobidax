import 'package:json_annotation/json_annotation.dart';
import 'package:mobidax_redux/account/account_state.dart';

part 'wallet_state.g.dart';

@JsonSerializable(nullable: false)
class WalletPageState {
  final int selectedTabIndex;
  final int selectedCardIndex;
  @JsonKey(nullable: true)
  final Beneficiary selectedBeneficiary;
  @JsonKey(ignore: true)
  final Exception error;

  WalletPageState(
      {this.selectedTabIndex,
      this.selectedCardIndex,
      this.error,
      this.selectedBeneficiary});

  WalletPageState copy(
          {int selectedTabIndex,
          int selectedCardIndex,
          Exception error,
          Beneficiary selectedBeneficiary}) =>
      WalletPageState(
          selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
          selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
          selectedBeneficiary: selectedBeneficiary,
          error: error);

  static WalletPageState initialState() => WalletPageState(
      selectedTabIndex: 0,
      selectedCardIndex: 0,
      error: null,
      selectedBeneficiary: null);

  factory WalletPageState.fromJson(Map<String, dynamic> json) =>
      _$WalletPageStateFromJson(json);

  Map<String, dynamic> toJson() => _$WalletPageStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletPageState &&
          runtimeType == other.runtimeType &&
          selectedTabIndex == other.selectedTabIndex &&
          error == other.error &&
          selectedBeneficiary == other.selectedBeneficiary &&
          selectedCardIndex == other.selectedCardIndex;

  @override
  int get hashCode =>
      selectedTabIndex.hashCode ^
      error.hashCode ^
      selectedCardIndex.hashCode ^
      selectedBeneficiary.hashCode;
}
