import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/exchange/exchange_state.dart';

import '../helpers/dialog_components.dart';
import '../helpers/sizes_helpers.dart';
import 'modal_window.dart';
import 'spacers.dart';

class AccountHistoryItem extends StatelessWidget {
  const AccountHistoryItem({
    this.exchange,
    this.option,
    this.firstColumnTitle,
    this.firstColumnValue,
    this.secondColumnTitle,
    this.secondColumnValue,
    this.icon,
    this.tradeItem,
    this.orderItem,
  });

  final String exchange;
  final String option;
  final String firstColumnTitle;
  final String firstColumnValue;
  final String secondColumnTitle;
  final String secondColumnValue;
  final Icon icon;
  final OrderItem orderItem;
  final TradeItem tradeItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        4,
        4,
        4,
        0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(
                2,
              ),
              child: Center(
                child: Text(
                  exchange,
                  style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(
                5,
              ),
              child: Center(
                child: Text(
                  tr(option).toUpperCase(),
                  style: option.contains('buy')
                      ? Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.green)
                      : Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  firstColumnTitle,
                  style: Theme.of(context).primaryTextTheme.overline.copyWith(
                        fontSize: 8,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                Text(
                  firstColumnValue,
                  style: Theme.of(context).primaryTextTheme.caption.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  secondColumnTitle,
                  style: Theme.of(context).primaryTextTheme.overline.copyWith(
                        fontSize: 8,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                Text(
                  secondColumnValue,
                  style: Theme.of(context).primaryTextTheme.caption.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ModalWindow(
                      titleName: tr('order_info'),
                      content: orderItem != null
                          ? InfoDialog(
                              dict: {
                                tr('date'): DateTime.fromMillisecondsSinceEpoch(
                                  orderItem.createdAt * 1000,
                                ).toString().split('.')[0],
                                tr('status'): orderItem.state,
                              },
                            )
                          : InfoDialog(
                              dict: {
                                tr('date'): DateTime.fromMillisecondsSinceEpoch(
                                  tradeItem.createdAt * 1000,
                                ).toString().split('.')[0],
                                tr('market_pair'): exchange,
                                tr('side'): option,
                                tr('price_label'): firstColumnValue,
                                tr('amount_label'): secondColumnValue,
                                tr('total_label'): tradeItem.total.toString()
                              },
                            ),
                    ),
                  );
                },
                child: Icon(
                  Icons.error_outline,
                  size: 25,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AccountActivitiesItem extends StatelessWidget {
  const AccountActivitiesItem({
    this.timestamp,
    this.name,
    this.source,
    this.status,
    this.userAgent,
    this.ip,
  });

  final String timestamp;
  final String name;
  final String status;
  final String source;
  final String ip;
  final String userAgent;

  @override
  Widget build(BuildContext context) {
    String date;
    String time;
    String datetime;
    String fixedAgent;
    datetime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(timestamp) * 1000,
    ).toString().split('.')[0];
    date = datetime.split(" ")[1];
    time = datetime.split(" ")[0];
    var res = name == null ? null : json.decode(name);
    fixedAgent = userAgent.split("(")[0];
    return Container(
      padding: const EdgeInsets.fromLTRB(
        4,
        4,
        4,
        0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  time,
                  style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  softWrap: true,
                ),
                Text(
                  date,
                  style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  softWrap: true,
                ),
              ],
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: displayWidth(context) * 0.2,
              ),
              padding: const EdgeInsets.all(
                2,
              ),
              child: Center(
                child: Text(
                  source,
                  style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  softWrap: true,
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {},
                child: status == 'Succeed'
                    ? const Icon(
                        Icons.check,
                        size: 25,
                        color: Colors.lightGreen,
                      )
                    : Icon(
                        Icons.clear,
                        size: 25,
                        color: Theme.of(context).colorScheme.error,
                      ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ModalWindow(
                      titleName: tr('activity_info'),
                      content: InfoDialog(
                        dict: {
                          tr('date'): datetime,
                          tr('action'): res == null ? "" : res["note"],
                          tr('reason'): res == null ? "" : res["reason"],
                          tr('status'): status,
                          tr('ip_addr'): ip,
                          tr('user_agent'): fixedAgent
                        },
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.error_outline,
                  size: 25,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AccountVerifyItem extends StatelessWidget {
  const AccountVerifyItem({
    this.icon,
    this.status,
    this.text,
    this.onPressed,
  });

  final Icon icon;
  final String text;
  final int status;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    if (status < 1)
      return Container(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(
                      0.5,
                    ),
              ),
              child: Icon(
                icon.icon,
                size: 25,
              ),
            ),
            SpaceW10(),
            Text(
              text,
              style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(
                          0.5,
                        ),
                  ),
            ),
            Expanded(
              child: Container(),
            ),
            RawMaterialButton(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 12,
              ),
              constraints: BoxConstraints(),
              onPressed: () {},
              fillColor: Theme.of(context).colorScheme.onPrimary.withOpacity(
                    0.5,
                  ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  6,
                ),
              ),
              child: Text(
                'Verify',
                style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
            )
          ],
        ),
      );
    else if (status == 1)
      return Container(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Column(
          children: <Widget>[
            Flex(
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
                    icon.icon,
                    size: 25,
                  ),
                ),
                SpaceW10(),
                Text(
                  text,
                  style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                Expanded(
                  child: Container(),
                ),
                RawMaterialButton(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 12,
                  ),
                  constraints: BoxConstraints(),
                  onPressed: onPressed,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      6,
                    ),
                  ),
                  child: Text(
                    'Verify',
                    style:
                        Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    else
      return Container(
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
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
              child: Icon(
                icon.icon,
                size: 25,
              ),
            ),
            SpaceW10(),
            Text(
              text,
              style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(
                          0.5,
                        ),
                  ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      );
  }
}
