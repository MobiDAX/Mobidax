import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobidax_redux/redux.dart';
import '../store.dart';

class AccountActivitiesPageModel extends BaseModel<AppState> {
  List<UserActivity> activities;
  final bool isLoading;

  AccountActivitiesPageModel({this.activities, this.isLoading});

  VoidCallback onFetchActivities;

  AccountActivitiesPageModel.build(
      {this.activities, this.isLoading, this.onFetchActivities})
      : super(equals: [activities, isLoading]);

  @override
  AccountActivitiesPageModel fromStore() => AccountActivitiesPageModel.build(
      activities: state.accountUserState.activities,
      isLoading: state.accountActivitiesPageState.isLoading,
      onFetchActivities: () {
        dispatch(FetchAccountActivities());
      });
}
