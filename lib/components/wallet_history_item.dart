import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/dialog_components.dart';
import 'modal_window.dart';

class WalletHistoryItem extends StatelessWidget {
  const WalletHistoryItem({
    this.timestamp,
    this.transactionId,
    this.amount,
    this.status,
    this.fee,
    this.currency,
    this.explorerTransaction,
    this.modalTitle,
    this.isWithdrawal,
  });

  final int timestamp;
  final String transactionId;
  final String currency;
  final String modalTitle;
  final String status;
  final double amount;
  final double fee;
  final bool isWithdrawal;
  final String explorerTransaction;

  @override
  Widget build(BuildContext context) {
    String date;
    String time;
    String datetime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
        .toString()
        .split('.')[0];
    date = datetime.split(" ")[1];
    time = datetime.split(" ")[0];

    getIconForStatus(status) {
      if (isWithdrawal) {
        if (transactionId == '' || transactionId == null) {
          if (status == 'Succeed') {
            return const Icon(
              Icons.check,
              size: 25,
              color: Colors.lightGreen,
            );
          } else if (status == 'Accepted') {
            return const Icon(
              Icons.loop,
              size: 25,
              color: Colors.orange,
            );
          } else {
            return Icon(
              Icons.clear,
              size: 25,
              color: Theme.of(context).colorScheme.error,
            );
          }
        } else {
          if (status == 'Succeed') {
            return const Icon(
              Icons.check,
              size: 25,
              color: Colors.lightGreen,
            );
          } else if (status == 'Accepted' ||
              status == 'Submitted' ||
              status == 'Processing' ||
              status == 'Confirming') {
            return const Icon(
              Icons.loop,
              size: 25,
              color: Colors.orange,
            );
          } else {
            return Icon(
              Icons.clear,
              size: 25,
              color: Theme.of(context).colorScheme.error,
            );
          }
        }
      } else {
        if (transactionId == '' || transactionId == null) {
          if (status == 'Accepted') {
            return const Icon(
              Icons.check,
              size: 25,
              color: Colors.lightGreen,
            );
          } else if (status == 'Submitted') {
            return const Icon(
              Icons.loop,
              size: 25,
              color: Colors.orange,
            );
          } else {
            return Icon(
              Icons.clear,
              size: 25,
              color: Theme.of(context).colorScheme.error,
            );
          }
        } else {
          if (status == 'Collected') {
            return const Icon(
              Icons.check,
              size: 25,
              color: Colors.lightGreen,
            );
          } else if (status == 'Accepted' || status == 'Submitted') {
            return const Icon(
              Icons.loop,
              size: 25,
              color: Colors.orange,
            );
          } else {
            return Icon(
              Icons.clear,
              size: 25,
              color: Theme.of(context).colorScheme.error,
            );
          }
        }
      }
    }

    _launchURL() async {
      var url = explorerTransaction.split('#{txid}')[0] + transactionId;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
        4,
        4,
        4,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          8.0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Row(
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
                ),
                Text(
                  date,
                  style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ],
            ),
            Expanded(
              child: TextButton(
                child: Text(
                  transactionId,
                  style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onPrimary,
                      decoration: TextDecoration.underline),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                onPressed: explorerTransaction != null
                    ? _launchURL
                    : explorerTransaction,
              ),
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {},
                child: getIconForStatus(
                  status,
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(
                  '$amount',
                  style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  softWrap: true,
                ),
              ),
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ModalWindow(
                      titleName: modalTitle,
                      content: isWithdrawal
                          ? InfoDialog(
                              dict: {
                                tr('date'): datetime,
                                tr('currency'): currency,
                                tr('amount_label'): '$amount',
                                tr('fee'): '$fee',
                                tr('status'): status
                              },
                            )
                          : InfoDialog(
                              dict: {
                                tr('date'): datetime,
                                tr('currency'): currency,
                                tr('amount_label'): '$amount',
                                tr('fee'): '$fee',
                                tr('status'): status
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
