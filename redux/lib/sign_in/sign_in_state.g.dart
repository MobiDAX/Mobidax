// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInPageState _$SignInPageStateFromJson(Map<String, dynamic> json) {
  return SignInPageState(
    signInLoading: json['signInLoading'] as bool,
    enabled2FA: json['enabled2FA'] as bool,
  );
}

Map<String, dynamic> _$SignInPageStateToJson(SignInPageState instance) =>
    <String, dynamic>{
      'signInLoading': instance.signInLoading,
      'enabled2FA': instance.enabled2FA,
    };
