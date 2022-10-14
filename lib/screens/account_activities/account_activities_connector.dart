import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';

import 'account_activities_widget.dart';

class AccountActivitiesPageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountActivitiesPageModel>(
      onInit: (st) {
        st.dispatch(
          FetchAccountActivities(),
        );
      },
      model: AccountActivitiesPageModel(),
      builder: (BuildContext context, AccountActivitiesPageModel vm) =>
          AccountActivitiesPage(
        activities: vm.activities,
        isLoading: vm.isLoading,
        onFetchActivities: vm.onFetchActivities,
      ),
    );
  }
}
