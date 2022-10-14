import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/exchange/exchange_state.dart';

import '../../components/tabbar_component.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    this.tradeHistory,
    this.orderHistory,
  });

  final List<TradeItem> tradeHistory;
  final List<OrderItem> orderHistory;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    var tabNames = [
      tr('orders_history_label'),
      tr('trades_history_label'),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: const AssetImage(
              'assets/icons/waves.png',
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
          Builder(
            builder: (context) => Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 36.0,
                ),
                constraints: const BoxConstraints(
                  maxWidth: 600.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: TabBarComp(
                          tabNames: tabNames,
                          selectedTabIndex: selectedTab,
                          onTabSelect: (index) {
                            setState(
                              () {
                                selectedTab = index;
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(
                          8.0,
                        ),
                        color: Theme.of(context).colorScheme.primary,
                        child: (widget.tradeHistory.length > 0 ||
                                widget.orderHistory.length > 0)
                            ? Table(
                                border: TableBorder(
                                  horizontalInside: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant
                                        .withOpacity(0.5),
                                  ),
                                ),
                                children: [
                                      TableRow(
                                        children: [
                                          Text(
                                            tr('date').toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            tr('market_pair').toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            tr('side').toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            tr('price_label').toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            tr('amount_label').toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            selectedTab > 0
                                                ? tr('total_label')
                                                    .toUpperCase()
                                                : tr('state').toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ] +
                                    List.generate(
                                      selectedTab > 0
                                          ? widget.tradeHistory.length
                                          : widget.orderHistory.length,
                                      (index) => selectedTab > 0
                                          ? TableRow(
                                              children: [
                                                TableCell(
                                                  child: Text(
                                                    DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                      widget.tradeHistory[index]
                                                              .createdAt *
                                                          1000,
                                                    )
                                                        .toString()
                                                        .split('.')[0]
                                                        .split(' ')[0]
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Text(
                                                    widget.tradeHistory[index]
                                                        .marketName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                TableCell(
                                                  child: selectedTab > 0
                                                      ? Text(
                                                          widget
                                                              .tradeHistory[
                                                                  index]
                                                              .side
                                                              .toUpperCase(),
                                                          style: widget
                                                                  .tradeHistory[
                                                                      index]
                                                                  .side
                                                                  .contains(
                                                                      'buy')
                                                              ? Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .green,
                                                                  )
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2
                                                                  .copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .error,
                                                                  ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      : Text(
                                                          widget
                                                              .orderHistory[
                                                                  index]
                                                              .side
                                                              .toUpperCase(),
                                                          style: widget
                                                                  .orderHistory[
                                                                      index]
                                                                  .side
                                                                  .contains(
                                                                      'buy')
                                                              ? Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .green,
                                                                  )
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2
                                                                  .copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .error,
                                                                  ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                ),
                                                TableCell(
                                                  child: Text(
                                                    widget.tradeHistory[index]
                                                        .price
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Text(
                                                    widget.tradeHistory[index]
                                                        .amount
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Text(
                                                    widget.tradeHistory[index]
                                                        .total
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : TableRow(
                                              children: [
                                                TableCell(
                                                  child: Text(
                                                    DateTime.fromMillisecondsSinceEpoch(
                                                            widget
                                                                    .orderHistory[
                                                                        index]
                                                                    .createdAt *
                                                                1000)
                                                        .toString()
                                                        .split('.')[0]
                                                        .split(' ')[0]
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Text(
                                                    widget.orderHistory[index]
                                                        .marketName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Text(
                                                    widget.orderHistory[index]
                                                        .side
                                                        .toUpperCase(),
                                                    style: widget
                                                            .orderHistory[index]
                                                            .side
                                                            .contains('buy')
                                                        ? Theme.of(context)
                                                            .textTheme
                                                            .bodyText2
                                                            .copyWith(
                                                              color:
                                                                  Colors.green,
                                                            )
                                                        : Theme.of(context)
                                                            .textTheme
                                                            .bodyText2
                                                            .copyWith(
                                                                color: Theme.of(
                                                              context,
                                                            )
                                                                    .colorScheme
                                                                    .error),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Text(
                                                    widget.orderHistory[index]
                                                        .price,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Text(
                                                    widget.orderHistory[index]
                                                        .originVolume,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Text(
                                                    widget.orderHistory[index]
                                                        .state,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                              )
                            : Center(
                                child: Text(
                                  tr('no_items'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
