import 'package:json_annotation/json_annotation.dart';

part 'account_activities_state.g.dart';

@JsonSerializable(nullable: false)
class AccountActivitiesPageState {
  final bool isLoading;

  AccountActivitiesPageState({this.isLoading});

  AccountActivitiesPageState copy({isLoading}) => AccountActivitiesPageState(
        isLoading: isLoading ?? this.isLoading,
      );

  static AccountActivitiesPageState initialState() =>
      AccountActivitiesPageState(
        isLoading: true,
      );

  factory AccountActivitiesPageState.fromJson(Map<String, dynamic> json) =>
      _$AccountActivitiesPageStateFromJson(json);

  Map<String, dynamic> toJson() => _$AccountActivitiesPageStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountActivitiesPageState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading;

  @override
  int get hashCode => isLoading.hashCode;
}
