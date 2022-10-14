import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/account/account_state.dart';

import '../../components/account_screen_items.dart';

class AccountActivitiesPage extends StatelessWidget {
  const AccountActivitiesPage({
    this.activities,
    this.isLoading,
    this.onFetchActivities,
  });

  final List<UserActivity> activities;
  final bool isLoading;
  final Function onFetchActivities;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          tr(
            'activities_label',
          ),
          style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor,
                  ),
                ),
              )
            : Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      child: RefreshIndicator(
                        color: Theme.of(context).accentColor,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        onRefresh: () async {
                          onFetchActivities();
                        },
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: activities.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 5,
                          ),
                          itemBuilder: (context, i) {
                            var item = activities[i];
                            return AccountActivitiesItem(
                              timestamp: item.createdAt,
                              status:
                                  '${item.result[0].toUpperCase()}${item.result.substring(1)}',
                              name: item.data,
                              source:
                                  '${item.action[0].toUpperCase()}${item.action.substring(1)}',
                              ip: item.userIP,
                              userAgent: item.userAgent,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
