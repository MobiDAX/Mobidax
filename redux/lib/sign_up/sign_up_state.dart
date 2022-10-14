import 'package:json_annotation/json_annotation.dart';

part 'sign_up_state.g.dart';

@JsonSerializable(nullable: false)
class SignUpPageState {
  final bool signUpLoading;
  @JsonKey(nullable: true, ignore: true)
  final Exception error;

  SignUpPageState({
    this.signUpLoading,
    this.error,
  });

  SignUpPageState copy({
    signUpLoading,
    error,
  }) =>
      SignUpPageState(
        signUpLoading: signUpLoading ?? this.signUpLoading,
        error: error,
      );

  static SignUpPageState initialState() => SignUpPageState(
        signUpLoading: false,
        error: null,
      );

  factory SignUpPageState.fromJson(Map<String, dynamic> json) =>
      _$SignUpPageStateFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpPageStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignUpPageState &&
          runtimeType == other.runtimeType &&
          signUpLoading == other.signUpLoading &&
          error == other.error;

  @override
  int get hashCode => signUpLoading.hashCode ^ error.hashCode;
}
