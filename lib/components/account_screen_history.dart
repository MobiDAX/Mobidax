import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/account/account_model.dart';
import 'package:mobidax_redux/exchange/exchange_state.dart';
import 'package:mobidax_redux/redux.dart';

import 'account_screen_items.dart';

class AccountScreenOrderHistory extends StatelessWidget {
  const AccountScreenOrderHistory({
    this.onOrderHistory,
  });

  final Function onOrderHistory;

  @override
  Widget build(BuildContext context) {
    final List<OrderItem> orders = ModalRoute.of(context).settings.arguments;
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
          tr('orders_history_label'),
          style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: (orders.length > 0)
          ? Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: RefreshIndicator(
                      color: Theme.of(context).accentColor,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      onRefresh: () async {
                        onOrderHistory();
                      },
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: orders.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 5,
                        ),
                        itemBuilder: (context, i) {
                          var item = orders[i];
                          return AccountHistoryItem(
                            orderItem: item,
                            exchange: item.marketName,
                            option: item.side,
                            firstColumnValue: item.price,
                            firstColumnTitle: tr('price_label') +
                                ' ' +
                                item.marketName.split('/')[1],
                            secondColumnValue: item.originVolume,
                            secondColumnTitle: tr('amount_label') +
                                ' ' +
                                item.marketName.split('/')[0],
                            icon: Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                tr('no_items'),
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
    );
  }
}

class AccountScreenOrderHistoryConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      builder: (BuildContext context, AccountPageModel vm) =>
          AccountScreenOrderHistory(
        onOrderHistory: vm.onFetchOrderHistory,
      ),
    );
  }
}

class AccountScreenTradeHistory extends StatelessWidget {
  const AccountScreenTradeHistory({
    this.onTradeHistory,
  });

  final Function onTradeHistory;

  @override
  Widget build(BuildContext context) {
    List<TradeItem> trades = ModalRoute.of(context).settings.arguments;
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
          tr('trades_history_label'),
          style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: (trades.length > 0)
          ? Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: RefreshIndicator(
                      color: Theme.of(context).accentColor,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      onRefresh: () async {
                        onTradeHistory();
                      },
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: trades.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 5,
                        ),
                        itemBuilder: (context, i) {
                          var item = trades[i];
                          return AccountHistoryItem(
                            exchange: item.marketName,
                            option: item.side,
                            firstColumnValue: item.price.toString(),
                            tradeItem: item,
                            firstColumnTitle: tr('price_label') +
                                " " +
                                item.marketName.split("/")[1],
                            secondColumnValue: item.amount.toString(),
                            secondColumnTitle: tr('amount_label') +
                                " " +
                                item.marketName.split("/")[1],
                            icon: Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                tr('no_items'),
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
    );
  }
}

class AccountScreenTradeHistoryConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      builder: (BuildContext context, AccountPageModel vm) =>
          AccountScreenTradeHistory(
        onTradeHistory: vm.getTradeHistory,
      ),
    );
  }
}
