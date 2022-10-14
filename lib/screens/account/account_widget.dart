import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

import '../../components/account_tab_pages.dart';
import '../../components/tabbar_component.dart';
import '../../helpers/capitalizer.dart';
import '../../helpers/sizes_helpers.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
    this.isAuthorized,
    this.user,
    this.trades,
    this.orders,
    this.selectedIndex,
    this.onTabSelect,
    this.onSignInSelect,
    this.onSignUpSelect,
    this.onClickOrderHistory,
    this.onClickTradeHistory,
    this.onClickActivities,
    this.onFetchOrderHistory,
    this.onChangePassword,
    this.getTradeHistory,
    this.onEnable2FA,
    this.onCreateApiKey,
    this.onDeleteApiKey,
    this.onUpdateApiKey,
    this.userApiKeys,
    this.changeLocale,
    this.onLogOut,
    this.onVerifyEmail,
    this.onVerifyIdentity,
  });

  final UserState user;
  final Function onSignInSelect;
  final Function onSignUpSelect;
  final Function onClickOrderHistory;
  final Function onClickTradeHistory;
  final Function() onClickActivities;
  final Function onChangePassword;
  final Function onEnable2FA;
  final Function onVerifyEmail;
  final Function onVerifyIdentity;
  final Function onTabSelect;
  final Function getTradeHistory;
  final Function changeLocale;
  final List<TradeItem> trades;
  final Function onFetchOrderHistory;
  final Function onLogOut;
  final bool isAuthorized;
  final List<OrderItem> orders;
  final int selectedIndex;
  final Function onCreateApiKey;
  final Function onDeleteApiKey;
  final Function onUpdateApiKey;
  final List<ApiKey> userApiKeys;

  Widget accountTabSelector(int selectedTabIndex) {
    switch (selectedTabIndex) {
      case 0:
        {
          return AccountTabHistory(
            trades: trades,
            onClickOrderHistory: onClickOrderHistory,
            onFetchOrderHistory: onFetchOrderHistory,
            getTradeHistory: getTradeHistory,
            orders: orders,
            onClickTradeHistory: onClickTradeHistory,
            onClickActivities: onClickActivities,
          );
        }
      case 1:
        {
          return AccountTabSettings(
            referralLink:
                'https://${GraphQLClientAPI.gqlServerHost}/signup?refid=${user.uid}#/',
            onChangePassword: onChangePassword,
            onEnable2Fa: onEnable2FA,
            status2FA: user.otp,
            onLogOut: onLogOut,
            changeLocale: changeLocale,
            userApiKeys: userApiKeys,
            onCreateApiKey: onCreateApiKey,
            onUpdateApiKey: onUpdateApiKey,
            onDeleteApiKey: onDeleteApiKey,
          );
        }
      case 2:
        {
          return AccountTabKYC(
            onVerifyEmail: onVerifyEmail,
            onVerifyIdentity: onVerifyIdentity,
            labels: user.labels,
          );
        }
      default:
        {
          return AccountTabHistory(
            trades: trades,
            onClickOrderHistory: onClickOrderHistory,
            orders: orders,
            onClickTradeHistory: onClickTradeHistory,
            onClickActivities: onClickActivities,
            onFetchOrderHistory: onFetchOrderHistory,
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    var tabNames = [
      tr('history_tab_label'),
      tr('setting_tab_label'),
      tr('kyc_tab_label')
    ];

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            /// Container Height 0.2
            Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? displayHeight(context) * 0.15
                  : displayWidth(context) * 0.15,
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    maxRadius: 40.0,
                    backgroundImage: NetworkImage(
                      Gravatar(user.email).imageUrl(
                        size: 1024,
                        fileExtension: true,
                        defaultImage: GravatarImage.robohash,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.045,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${user.profile != null ? capitalize(user.profile.firstName) : ""} ${user.profile != null ? capitalize(user.profile.lastName) : ""}",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .copyWith(
                              fontSize: 20.0,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      Text(
                        'UID: ${user.uid}',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyText2
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyText2
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                ],
              ),
            ),
            TabBarComp(
              tabNames: tabNames,
              onTabSelect: onTabSelect,
              selectedTabIndex: selectedIndex,
            ),

            /// Container Height 0.55 + 0.01 from margins
            Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? displayHeight(context) * 0.63
                  : displayHeight(context) * 0.63,
              margin: MediaQuery.of(context).orientation == Orientation.portrait
                  ? EdgeInsets.fromLTRB(
                      displayHeight(context) * 0.01,
                      displayHeight(context) * 0.005,
                      displayHeight(context) * 0.01,
                      displayHeight(context) * 0.01,
                    )
                  : EdgeInsets.fromLTRB(
                      displayWidth(context) * 0.01,
                      0,
                      displayWidth(context) * 0.01,
                      displayWidth(context) * 0.01,
                    ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    8.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 4,
                ),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    accountTabSelector(selectedIndex),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
