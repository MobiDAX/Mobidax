import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobidax_redux/redux.dart';

import '../helpers/color_helper.dart';
import 'modal_window.dart';
import 'order_page_item.dart';
import 'spacers.dart';

class OrderTabPageOrders extends StatelessWidget {
  const OrderTabPageOrders({
    this.userOrders,
    this.selectedMarket,
    this.userSession,
    this.onCancelOrder,
  });

  final List<OrderItem> userOrders;
  final UserSessionState userSession;
  final Function(String barongSession, int orderId) onCancelOrder;
  final MarketItemState selectedMarket;

  @override
  Widget build(BuildContext context) {
    return userOrders.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: userOrders.length > 20 ? 20 : userOrders.length,
            itemBuilder: (context, i) {
              return Column(
                children: <Widget>[
                  OrderPageItem(
                    option: userOrders[i].side,
                    firstColumnTitle: tr('price_label') +
                        ' ' +
                        selectedMarket.name.split('/')[1],
                    firstColumnValue: double.parse(userOrders[i].price)
                        .toStringAsFixed(selectedMarket.pricePrecision),
                    secondColumnTitle: tr('amount_label') +
                        ' ' +
                        selectedMarket.name.split('/')[0],
                    secondColumnValue: double.parse(userOrders[i].originVolume)
                        .toStringAsFixed(selectedMarket.amountPrecision),
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 25,
                    ),
                    onIconTap: () {
                      onCancelOrder(
                        userSession.barongSession,
                        userOrders[i].id,
                      );
                    },
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
                ],
              );
            },
          )
        : Center(
            child: Text(
              tr('no_items'),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          );
  }
}

class OrderTabPageTrades extends StatelessWidget {
  const OrderTabPageTrades({
    this.marketTrades,
    this.selectedMarket,
  });

  final List<TradeItem> marketTrades;
  final MarketItemState selectedMarket;

  @override
  Widget build(BuildContext context) {
    return marketTrades.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: marketTrades.length > 20 ? 20 : marketTrades.length,
            itemBuilder: (context, i) {
              return Column(
                children: <Widget>[
                  OrderPageItem(
                    option: marketTrades[i].side,
                    firstColumnTitle: tr('price_label') +
                        ' ' +
                        selectedMarket.name.split('/')[1],
                    firstColumnValue: marketTrades[i]
                        .price
                        .toStringAsFixed(selectedMarket.pricePrecision),
                    secondColumnTitle: tr('amount_label') +
                        ' ' +
                        selectedMarket.name.split('/')[0],
                    secondColumnValue: marketTrades[i]
                        .amount
                        .toStringAsFixed(selectedMarket.amountPrecision),
                    icon: const Icon(
                      Icons.info_outline,
                    ),
                    onIconTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => ModalWindow(
                                titleName: tr('trade_info'),
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'ID',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                    Text(
                                      marketTrades[i].id,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                    SpaceH10(),
                                    Text(
                                      tr('date'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                    Text(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        (marketTrades[i].createdAt * 1000)
                                            .round(),
                                      ).toString().split('.')[0],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                    SpaceH10(),
                                    Text(
                                      tr('price_label') +
                                          ' ' +
                                          selectedMarket.name.split('/')[1],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                    Text(
                                      marketTrades[i].price.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                    SpaceH10(),
                                    Text(
                                      tr('amount_label') +
                                          ' ' +
                                          selectedMarket.name.split('/')[0],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                    Text(
                                      marketTrades[i].amount.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                    SpaceH10(),
                                    Text(
                                      tr('total_label') +
                                          ' ' +
                                          selectedMarket.name.split('/')[1],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                    Text(
                                      marketTrades[i].total.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                  ],
                                ),
                              ));
                    },
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primaryVariant,
                  )
                ],
              );
            },
          )
        : Center(
            child: Text(
              tr('no_items'),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          );
  }
}

class AllTrades extends StatelessWidget {
  const AllTrades({
    this.marketTrades,
    this.selectedMarket,
    this.selectedPrecision,
  });

  final List<TradeItem> marketTrades;
  final MarketItemState selectedMarket;
  final int selectedPrecision;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          toolbarHeight: 30,
          automaticallyImplyLeading: false,
          title: Table(
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 2,
                        bottom: 2,
                        right: 20,
                      ),
                      child: Center(
                        child: Text(
                          tr('date'),
                          style: Theme.of(context).textTheme.overline.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 2,
                        bottom: 2,
                        left: 5,
                        right: 5,
                      ),
                      child: Center(
                        child: Text(
                          tr('amount_label').toUpperCase(),
                          style: Theme.of(context).textTheme.overline.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 2,
                        bottom: 2,
                        left: 20,
                      ),
                      child: Center(
                        child: Text(
                          tr('price_label').toUpperCase(),
                          style: Theme.of(context).textTheme.overline.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          pinned: true,
          floating: true,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Table(
                children: List.generate(
                  marketTrades.length,
                  (i) => TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                          ),
                          child: Center(
                            child: Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                (marketTrades[i].createdAt * 1000),
                              ).toString().split(' ')[1].split('.')[0],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: takerTypeColorHelper(
                                        marketTrades[i].side),
                                  ),
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
                              marketTrades[i].amount.toStringAsFixed(
                                  selectedMarket.amountPrecision),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: takerTypeColorHelper(
                                        marketTrades[i].side),
                                  ),
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
                              marketTrades[i].price.toStringAsFixed(
                                  selectedMarket.pricePrecision),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: takerTypeColorHelper(
                                        marketTrades[i].side),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class UserOrders extends StatelessWidget {
  const UserOrders({
    this.userOrders,
    this.selectedMarket,
    this.userSession,
    this.onCancelOrder,
  });

  final List<OrderItem> userOrders;
  final MarketItemState selectedMarket;
  final UserSessionState userSession;
  final Function(String barongSession, int orderId) onCancelOrder;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          toolbarHeight: 30,
          pinned: true,
          floating: true,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          automaticallyImplyLeading: false,
          title: Table(
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Center(
                      child: Text(
                        tr('side').toUpperCase(),
                        style: Theme.of(context).textTheme.overline.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        tr('price_label').toUpperCase(),
                        style: Theme.of(context).textTheme.overline.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        tr('amount_label').toUpperCase(),
                        style: Theme.of(context).textTheme.overline.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(
                        tr('cancel').toUpperCase(),
                        style: Theme.of(context).textTheme.overline.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Table(
                children: List.generate(
                  userOrders.length,
                  (i) => TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                          ),
                          child: Center(
                            child: Text(
                              userOrders[i].side.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: takerTypeColorHelper(
                                        userOrders[i].side),
                                  ),
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
                              double.parse(userOrders[i].price).toStringAsFixed(
                                  selectedMarket.pricePrecision),
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
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                          ),
                          child: Center(
                            child: Text(
                              double.parse(userOrders[i].originVolume)
                                  .toStringAsFixed(
                                      selectedMarket.amountPrecision),
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
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              onCancelOrder(
                                userSession.barongSession,
                                userOrders[i].id,
                              );
                            },
                            child: Icon(
                              Icons.clear,
                              color: Theme.of(context).colorScheme.onBackground,
                              size: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .fontSize,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
