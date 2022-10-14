import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/spacers.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

import '../../components/account_screen_items.dart';
import '../../components/account_tab_pages.dart';
import '../../components/create_api_key.dart';
import '../../components/modal_window.dart';
import '../../components/otp_code.dart';
import '../../helpers/capitalizer.dart';

class WebAccountPage extends StatefulWidget {
  const WebAccountPage({
    this.isAuthorized,
    this.user,
    this.trades,
    this.orders,
    this.authenteqEnabled,
    this.selectedIndex,
    this.onTabSelect,
    this.onSignInSelect,
    this.onSignUpSelect,
    this.onClickOrderHistory,
    this.onClickTradeHistory,
    this.onClickActivities,
    this.onFetchOrderHistory,
    this.onChangePassword,
    this.onCreateApiKey,
    this.onDeleteApiKey,
    this.onUpdateApiKey,
    this.userApiKeys,
    this.getTradeHistory,
    this.onEnable2FA,
    this.changeLocale,
    this.onLogOut,
    this.onVerifyEmail,
    this.onFetchActivities,
    this.activities,
    this.onVerifyIdentity,
  });

  final UserState user;
  final Function onSignInSelect;
  final Function onSignUpSelect;
  final Function onClickOrderHistory;
  final Function onClickTradeHistory;
  final Function onClickActivities;
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
  final bool authenteqEnabled;
  final List<OrderItem> orders;
  final int selectedIndex;
  final List<UserActivity> activities;
  final Function onFetchActivities;
  final Function onCreateApiKey;
  final Function onDeleteApiKey;
  final Function onUpdateApiKey;
  final List<ApiKey> userApiKeys;

  @override
  _WebAccountPageState createState() => _WebAccountPageState();
}

class _WebAccountPageState extends State<WebAccountPage> {
  @override
  Widget build(BuildContext context) {
    var userApiKeys = (widget.userApiKeys != null) ? widget.userApiKeys : [];
    return SafeArea(
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 600,
            padding: const EdgeInsets.only(
              top: 36.0,
              bottom: 36.0,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(
                    36.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
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
                          Gravatar(widget.user.email).imageUrl(
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
                            "${widget.user.profile != null ? capitalize(widget.user.profile.firstName) : ""} ${widget.user.profile != null ? capitalize(widget.user.profile.lastName) : ""}",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .copyWith(
                                  fontSize: 20.0,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                          Text(
                            'UID: ${widget.user.uid}',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyText2
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                          Text(
                            widget.user.email,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyText2
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SpaceH24(),
                Container(
                  padding: const EdgeInsets.all(
                    36.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr('setting_tab_label'),
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                      SpaceH24(),
                      AccountTabSettings(
                        referralLink:
                            '${Uri.base}signup?refid=${widget.user.uid}#/',
                        onChangePassword: widget.onChangePassword,
                        onEnable2Fa: widget.onEnable2FA,
                        status2FA: widget.user.otp,
                        onLogOut: widget.onLogOut,
                        changeLocale: widget.changeLocale,
                      ),
                    ],
                  ),
                ),
                SpaceH24(),
                Container(
                  padding: const EdgeInsets.all(
                    36.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr('verification'),
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                      SpaceH24(),
                      AccountTabKYC(
                        onVerifyEmail: widget.onVerifyEmail,
                        onVerifyIdentity: widget.onVerifyIdentity,
                        labels: widget.user.labels,
                      ),
                    ],
                  ),
                ),
                SpaceH24(),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 36.0,
                          left: 36.0,
                          top: 16.0,
                          bottom: 16.0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              tr('my_api_keys'),
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                            const Spacer(),
                            RawMaterialButton(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 12,
                              ),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                if (widget.user.otp) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ModalWindow(
                                      titleName:
                                          tr('enter_2fa_code_from_the_app'),
                                      content: OtpField(
                                        bgColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        onVerifyOTP: (String value) {
                                          widget.onCreateApiKey(
                                            value,
                                            (String kid, String secret) {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    ModalWindow(
                                                  titleName: tr(
                                                    '',
                                                  ),
                                                  content: CreateApiKeyModel(
                                                    kid: kid,
                                                    secret: secret,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  widget.onEnable2FA();
                                }
                              },
                              fillColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  6,
                                ),
                              ),
                              child: Text(
                                tr('withdraw_create'),
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryVariant,
                                    ),
                              ),
                            )
                          ],
                        ),
                      ),
                      (userApiKeys.length >= 1)
                          ? SingleChildScrollView(
                              child: Table(
                                defaultColumnWidth: const FixedColumnWidth(
                                  150,
                                ),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Center(
                                              child: Text(
                                                tr('kid'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .overline
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Center(
                                              child: Text(
                                                tr('algorithm'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .overline
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Center(
                                              child: Text(
                                                tr('state_api_key'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .overline
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Center(
                                              child: Text(
                                                '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .overline
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ] +
                                    List.generate(
                                      userApiKeys.length,
                                      (i) => TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  userApiKeys[i].kid.toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  userApiKeys[i]
                                                      .algorithm
                                                      .toUpperCase(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                              ),
                                              child: Center(
                                                child: Switch(
                                                  onChanged: (valueSwitch) {
                                                    if (widget.user.otp) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            ModalWindow(
                                                          titleName: tr(
                                                              'enter_2fa_code_from_the_app'),
                                                          content: OtpField(
                                                            bgColor: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            onVerifyOTP: (String
                                                                valueOtp) {
                                                              widget.onUpdateApiKey(
                                                                  valueOtp,
                                                                  userApiKeys[i]
                                                                      .kid,
                                                                  valueSwitch);
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      widget.onEnable2FA();
                                                    }
                                                  },
                                                  value: userApiKeys[i].enabled,
                                                  activeTrackColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primaryVariant,
                                                  activeColor: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                  inactiveThumbColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                  inactiveTrackColor: Theme.of(
                                                          context)
                                                      .unselectedWidgetColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                              ),
                                              child: GestureDetector(
                                                child: Icon(
                                                  Icons.clear,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                  size: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .fontSize,
                                                ),
                                                onTap: () {
                                                  if (widget.user.otp) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          ModalWindow(
                                                        titleName: tr(
                                                            'enter_2fa_code_from_the_app'),
                                                        content: OtpField(
                                                          bgColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          onVerifyOTP:
                                                              (String value) {
                                                            widget
                                                                .onDeleteApiKey(
                                                                    value,
                                                                    userApiKeys[
                                                                            i]
                                                                        .kid);
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    widget.onEnable2FA();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: Center(
                                child: Text(
                                  tr('you_have_no_API_keys'),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                SpaceH24(),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 36.0,
                          left: 36.0,
                          top: 16.0,
                          bottom: 16.0,
                        ),
                        child: Text(
                          tr('activity_info'),
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ),
                      RefreshIndicator(
                        color: Theme.of(context).accentColor,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        onRefresh: () async {
                          widget.onFetchActivities();
                        },
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: widget.activities.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 5,
                          ),
                          itemBuilder: (context, i) {
                            var item = widget.activities[i];
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
