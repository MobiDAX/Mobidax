import 'package:country_code_picker/country_code.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobidax_redux/redux.dart';

import '../helpers/capitalizer.dart';
import '../helpers/error_notifier.dart';
import '../helpers/sizes_helpers.dart';
import '../utils/config.dart';
import 'spacers.dart';

class AccountTabHistory extends StatelessWidget {
  const AccountTabHistory({
    this.orders,
    this.trades,
    this.onClickTradeHistory,
    this.onClickOrderHistory,
    this.onClickActivities,
    this.getTradeHistory,
    this.onFetchOrderHistory,
  });

  final Function onClickOrderHistory;
  final Function() onClickActivities;
  final List<TradeItem> trades;
  final Function onClickTradeHistory;
  final List<OrderItem> orders;
  final Function onFetchOrderHistory;
  final Function getTradeHistory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              getTradeHistory();
              Navigator.of(context).pushNamed(
                '/accountTradeHistory',
                arguments: trades,
              );
            },
            child: Text(
              tr('trades_history_label'),
              style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          ),
        ),
        SpaceH10(),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              onFetchOrderHistory();
              Navigator.of(context).pushNamed(
                '/accountOrderHistory',
                arguments: orders,
              );
            },
            child: Text(
              tr('orders_history_label'),
              style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          ),
        ),
        SpaceH10(),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onClickActivities,
            child: Text(
              tr('activities_label'),
              style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class AccountTabSettings extends StatelessWidget {
  AccountTabSettings({
    this.referralLink,
    this.onChangePassword,
    this.onEnable2Fa,
    this.onLogOut,
    this.changeLocale,
    this.status2FA,
    this.onCreateApiKey,
    this.onDeleteApiKey,
    this.onUpdateApiKey,
    this.userApiKeys,
  });

  final String referralLink;
  final Function onChangePassword;
  final Function onEnable2Fa;
  final Function onLogOut;
  final Function changeLocale;
  final bool status2FA;
  final Function onCreateApiKey;
  final Function onDeleteApiKey;
  final Function onUpdateApiKey;
  final List<ApiKey> userApiKeys;

  final locales = supportedLocales
      .map(
        (e) => DropdownMenuItem<Locale>(
          value: e,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                CountryCode.fromCode(e.countryCode).flagUri,
                package: 'country_code_picker',
                alignment: Alignment.bottomCenter,
                width: 24.0,
              ),
              Text(
                e.languageCode.toUpperCase(),
              ),
            ],
          ),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.primaryVariant,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          tr('referral_link_label'),
                          style: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          referralLink,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: referralLink,
                            ),
                          );
                          SnackBarNotifier.createSnackBar(
                            tr('copied'),
                            context,
                          );
                        },
                        child: Text(
                          tr('copy_label'),
                          style: Theme.of(context)
                              .primaryTextTheme
                              .button
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? displayHeight(context) * 0.05
                : displayHeight(context) * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 100.0,
                        child: Text(
                          tr('twoFA_status_label'),
                          overflow: TextOverflow.fade,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: status2FA
                            ? Text(
                                tr('enabled_label'),
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle2
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                              )
                            : Text(
                                tr('disabled_label'),
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle2
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                              ),
                      ),
                    ],
                  ),
                  Switch(
                    onChanged: (value) {
                      onEnable2Fa();
                    },
                    value: status2FA,
                    activeTrackColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    activeColor: Theme.of(context).colorScheme.onBackground,
                    inactiveThumbColor: Theme.of(context).colorScheme.onPrimary,
                    inactiveTrackColor: Theme.of(context).unselectedWidgetColor,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(
                  4.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).colorScheme.primaryVariant,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    style: BorderStyle.solid,
                  ),
                ),
                width: 100,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Locale>(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                    isExpanded: true,
                    value: EasyLocalization.of(context).locale,
                    focusColor: Theme.of(context).colorScheme.primaryVariant,
                    iconEnabledColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    elevation: 0,
                    selectedItemBuilder: (BuildContext context) {
                      return supportedLocales
                          .map(
                            (e) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  CountryCode.fromCode(e.countryCode).flagUri,
                                  package: 'country_code_picker',
                                  width: 24.0,
                                ),
                                Text(
                                  e.languageCode.toUpperCase(),
                                ),
                              ],
                            ),
                          )
                          .toList();
                    },
                    items: locales,
                    onChanged: (value) {
                      EasyLocalization.of(context).locale = value;
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? displayHeight(context) * 0.05
                : displayHeight(context) * 0.05,
          ),
          Container(
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/accountChangePassword',
                );
              },
              child: Text(
                tr('change_password_label'),
                style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
            ),
          ),
          SpaceH20(),
          (isDesktop(context))
              ? SizedBox()
              : Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/apiKey');
                    },
                    child: Text(
                      tr('my_api_keys'),
                      style: Theme.of(context)
                          .primaryTextTheme
                          .bodyText1
                          .copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                    ),
                  ),
                ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 15.5,
          ),
          Container(
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                onLogOut();
              },
              child: Text(
                tr('log_out'),
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.secondaryVariant,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountTabKYC extends StatelessWidget {
  const AccountTabKYC({
    this.onVerifyEmail,
    this.onVerifyIdentity,
    this.labels,
  });

  final Function onVerifyEmail;
  final Function onVerifyIdentity;
  final List<UserLabel> labels;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: const IconThemeData(
        color: Colors.black,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            barongLabels.length,
            (index) => Container(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(
                      8,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Icon(
                      barongLabels.entries.toList()[index].value["icon"],
                      size: 25,
                    ),
                  ),
                  SizedBox(
                    width: displayWidth(context) * 0.02,
                  ),
                  Container(
                    child: Text(
                      "${barongLabels.entries.toList()[index].value["translation"]} ${tr('verification')}",
                      style:
                          Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  labels.firstWhere(
                              (element) =>
                                  element.key ==
                                  barongLabels.entries.toList()[index].key,
                              orElse: () => null) !=
                          null
                      ? labels
                                  .firstWhere(
                                      (element) =>
                                          element.key ==
                                          barongLabels.entries
                                              .toList()[index]
                                              .key,
                                      orElse: () => null)
                                  .value ==
                              barongLabels.entries
                                  .toList()[index]
                                  .value["value"]
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 6,
                              ),
                              child: Text(
                                capitalize(
                                  tr(barongLabels.entries.toList()[index].key +
                                      '_value'),
                                ),
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.green,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 6,
                              ),
                              child: Text(
                                capitalize(labels
                                    .firstWhere((element) =>
                                        element.key ==
                                        barongLabels.entries
                                            .toList()[index]
                                            .key)
                                    .value),
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1
                                    .copyWith(color: Colors.yellow),
                                textAlign: TextAlign.center,
                              ),
                            )
                      : RawMaterialButton(
                          disabledElevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 12,
                          ),
                          constraints: BoxConstraints(),
                          onPressed: (labels.firstWhere(
                                          (element) => element.key == 'phone',
                                          orElse: () => null) ==
                                      null &&
                                  barongLabels.entries
                                          .toList()[index]
                                          .value["translation"] ==
                                      "Phone")
                              ? () {
                                  Navigator.of(context).pushNamed(barongLabels
                                      .entries
                                      .toList()[index]
                                      .value["path"]);
                                }
                              : (barongLabels.entries
                                              .toList()[index]
                                              .value["translation"] ==
                                          "Identity") &&
                                      labels.firstWhere(
                                              (element) =>
                                                  element.key == 'phone',
                                              orElse: () => null) !=
                                          null
                                  ? () {
                                      Navigator.of(context).pushNamed(
                                          barongLabels.entries
                                              .toList()[index]
                                              .value["path"]);
                                    }
                                  : null,
                          fillColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tr('verify_label'),
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
