import 'package:json_annotation/json_annotation.dart';

part 'enable_2fa_state.g.dart';

@JsonSerializable(nullable: false)
class Enable2FAPageState {
  final String secret;

  Enable2FAPageState({
    this.secret,
  });

  Enable2FAPageState copy({secret}) => Enable2FAPageState(
        secret: secret ?? this.secret,
      );

  static Enable2FAPageState initialState() => Enable2FAPageState(
        secret: "",
      );

  factory Enable2FAPageState.fromJson(Map<String, dynamic> json) =>
      _$Enable2FAPageStateFromJson(json);

  Map<String, dynamic> toJson() => _$Enable2FAPageStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Enable2FAPageState &&
          runtimeType == other.runtimeType &&
          secret == other.secret;

  @override
  int get hashCode => secret.hashCode;
}
