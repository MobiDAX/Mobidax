import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';

import 'create_api_key.dart';
import 'modal_window.dart';
import 'otp_code.dart';

class AccountApiKey extends StatelessWidget {
  AccountApiKey({
    this.userApiKeys,
    this.onCreateApiKey,
    this.onUpdateApiKey,
    this.onDeleteApiKey,
    this.onEnable2FA,
    this.user,
  });

  final List<ApiKey> userApiKeys;
  final Function onCreateApiKey;
  final Function onDeleteApiKey;
  final Function onUpdateApiKey;
  final Function onEnable2FA;
  final UserState user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          if (user.otp) {
            showDialog(
              context: context,
              builder: (context) => ModalWindow(
                titleName: tr(
                  'enter_2fa_code_from_the_app',
                ),
                content: OtpField(
                  bgColor: Theme.of(context).colorScheme.primary,
                  onVerifyOTP: (String value) {
                    onCreateApiKey(
                      value,
                      (String kid, String secret) {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => ModalWindow(
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
            onEnable2FA();
          }
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          tr('my_api_keys'),
          style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
      body: Container(
        child: (userApiKeys.length >= 1)
            ? CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                    toolbarHeight: 30,
                    title: Container(
                      child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: FlexColumnWidth(4),
                            1: FlexColumnWidth(4),
                            2: FlexColumnWidth(4),
                            3: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: Text(
                                        tr('kid'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontSize: 12,
                                            ),
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
                                            fontSize: 12,
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
                                            fontSize: 12,
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
                                                  .onBackground),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                    ),
                    pinned: false,
                    floating: true,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    backgroundColor: Colors.transparent),
                SliverList(
                    delegate: SliverChildListDelegate(
                  [
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(4),
                        2: FlexColumnWidth(4),
                        3: FlexColumnWidth(1),
                      },
                      children: List.generate(
                        userApiKeys.length,
                        (i) => TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 4.0, top: 4.0, left: 5.0),
                                child: Center(
                                  child: Text(
                                    userApiKeys[i].kid.toString(),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Center(
                                  child: Text(
                                    userApiKeys[i].algorithm.toUpperCase(),
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
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 4.0, right: 12.0),
                                child: Center(
                                  child: Switch(
                                    onChanged: (valueSwitch) {
                                      if (user.otp) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => ModalWindow(
                                            titleName: tr(
                                              'enter_2fa_code_from_the_app',
                                            ),
                                            content: OtpField(
                                              bgColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              onVerifyOTP: (String valueOtp) {
                                                onUpdateApiKey(
                                                  valueOtp,
                                                  userApiKeys[i].kid,
                                                  valueSwitch,
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        onEnable2FA();
                                      }
                                    },
                                    value: userApiKeys[i].enabled,
                                    activeTrackColor: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                    activeColor: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    inactiveThumbColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    inactiveTrackColor:
                                        Theme.of(context).unselectedWidgetColor,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, right: 5),
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
                                    if (user.otp) {
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
                                              onDeleteApiKey(
                                                  value, userApiKeys[i].kid);
                                            },
                                          ),
                                        ),
                                      );
                                    } else {
                                      onEnable2FA();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
              ])
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    tr('you_have_no_API_keys'),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class ApiKeyConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      builder: (BuildContext context, AccountPageModel vm) => AccountApiKey(
        onCreateApiKey: vm.onCreateApiKey,
        onDeleteApiKey: vm.onDeleteApiKey,
        onUpdateApiKey: vm.onUpdateApiKey,
        userApiKeys: vm.userApiKeys,
        onEnable2FA: vm.onEnable2FA,
        user: vm.user,
      ),
    );
  }
}
