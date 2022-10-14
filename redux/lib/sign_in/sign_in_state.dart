import 'package:json_annotation/json_annotation.dart';

part 'sign_in_state.g.dart';

@JsonSerializable(nullable: false)
class SignInPageState {
  final bool signInLoading;
  @JsonKey(ignore: true, nullable: true)
  final Exception error;
  final bool enabled2FA;

  SignInPageState({this.signInLoading, this.error, this.enabled2FA});

  SignInPageState copy({signInLoading, error, enabled2FA}) => SignInPageState(
      signInLoading: signInLoading ?? this.signInLoading,
      error: error,
      enabled2FA: enabled2FA ?? this.enabled2FA);

  static SignInPageState initialState() =>
      SignInPageState(signInLoading: false, error: null, enabled2FA: false);

  factory SignInPageState.fromJson(Map<String, dynamic> json) =>
      _$SignInPageStateFromJson(json);

  Map<String, dynamic> toJson() => _$SignInPageStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignInPageState &&
          runtimeType == other.runtimeType &&
          signInLoading == other.signInLoading &&
          error == other.error &&
          enabled2FA == other.enabled2FA;

  @override
  int get hashCode =>
      signInLoading.hashCode ^ error.hashCode ^ enabled2FA.hashCode;
}
