import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';

import '../helpers/color_helper.dart';
import '../helpers/orderbook_helper.dart';
import '../helpers/sizes_helpers.dart';
import 'modal_window.dart';
import 'order_placement_screen.dart';
import 'orderbook_item.dart';

class Orderbook extends StatelessWidget {
  const Orderbook(
      {this.widthFactor,
      this.itemSide,
      this.orderbook,
      this.balances,
      this.selectedMarket,
      this.onPlaceOrder,
      this.vertical = false,
      this.userSession,
      this.isAuthourized});

  final double widthFactor;
  final orderSide itemSide;
  final OrderbookState orderbook;
  final MarketItemState selectedMarket;
  final Function onPlaceOrder;
  final UserSessionState userSession;
  final List<UserBalanceItemState> balances;
  final bool vertical;
  final bool isAuthourized;

  Widget buildVertical(BuildContext context, bool vertical) {
    double askVolume = 0.0;
    double bidVolume = 0.0;

    var asks = orderbook.asks;
    asks.sort((a, b) => a.price.compareTo(b.price));

    var bids = orderbook.bids;

    bids.sort((a, b) => b.price.compareTo(a.price));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: displayHeight(context) * 0.4,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              reverse: true,
              child: Table(
                columnWidths: {
                  1: FlexColumnWidth(0.01),
                },
                children: List.generate(
                  asks.length,
                  (i) => TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              userSession.barongSession == ''
                                  ? Navigator.pushNamed(
                                      context,
                                      '/signInPage',
                                    )
                                  : showDialog(
                                      context: context,
                                      builder: (context) => ModalWindow(
                                        titleName: tr('place_order'),
                                        content: OrderPlacementScreen(
                                          balances: balances,
                                          isAuthourized: isAuthourized,
                                          onPlaceOrder: onPlaceOrder,
                                          userSession: userSession,
                                          selectedMarket: selectedMarket,
                                          limitSelected: true,
                                          side: orderSide.buy,
                                          price: asks.asMap().containsKey(i)
                                              ? asks.elementAt(i)?.price
                                              : 0.0,
                                          amount: asks.asMap().containsKey(i)
                                              ? asks.elementAt(i)?.amount
                                              : 0.0,
                                        ),
                                      ),
                                    );
                            },
                            child: OrderbookItem(
                              selectedMarket: selectedMarket,
                              vertical: vertical,
                              widthFactor: orderWidthHelper(
                                  orderbook,
                                  asks.asMap().containsKey(i)
                                      ? askVolume += asks.elementAt(i).amount
                                      : 0.0),
                              itemSide: orderSide.sell,
                              amount: asks.asMap().containsKey(i)
                                  ? asks.elementAt(i)?.amount
                                  : '',
                              price: asks.asMap().containsKey(i)
                                  ? asks.elementAt(i)?.price
                                  : '',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).reversed.toList(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.primaryVariant,
                ),
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.primaryVariant,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  Text(
                    '${selectedMarket.ticker.last.toStringAsFixed(selectedMarket.pricePrecision)} ${selectedMarket.quoteUnit.id.toUpperCase()}',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 24.0,
                          color: colorHelper(
                            selectedMarket.ticker.priceChangePercent,
                          ),
                        ),
                  ),
                  Text(
                    tr(
                      'last_market_price',
                    ),
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(
                                0.8,
                              ),
                        ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: displayHeight(context) * 0.45 - 10.0,
          child: SingleChildScrollView(
            child: Table(
              columnWidths: {1: FlexColumnWidth(0.01)},
              children: List.generate(
                bids.length,
                (i) => TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            userSession.barongSession == ''
                                ? Navigator.pushNamed(context, '/signInPage')
                                : showDialog(
                                    context: context,
                                    builder: (context) => ModalWindow(
                                      titleName: tr('place_order'),
                                      content: OrderPlacementScreen(
                                        balances: balances,
                                        isAuthourized: isAuthourized,
                                        userSession: userSession,
                                        onPlaceOrder: onPlaceOrder,
                                        selectedMarket: selectedMarket,
                                        limitSelected: true,
                                        side: orderSide.sell,
                                        price: bids.asMap().containsKey(i)
                                            ? bids.elementAt(i)?.price
                                            : 0.0,
                                        amount: bids.asMap().containsKey(i)
                                            ? bids.elementAt(i)?.amount
                                            : 0.0,
                                      ),
                                    ),
                                  );
                          },
                          child: OrderbookItem(
                            selectedMarket: selectedMarket,
                            vertical: vertical,
                            widthFactor: orderWidthHelper(
                                orderbook,
                                bids.asMap().containsKey(i)
                                    ? bidVolume += bids.elementAt(i).amount
                                    : 0.0),
                            itemSide: orderSide.buy,
                            amount: bids.asMap().containsKey(i)
                                ? bids.elementAt(i)?.amount
                                : '',
                            price: bids.asMap().containsKey(i)
                                ? bids.elementAt(i)?.price
                                : '',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var asks = orderbook.asks;
    asks.sort((a, b) => a.price.compareTo(b.price));

    var bids = orderbook.bids;

    bids.sort((a, b) => b.price.compareTo(a.price));

    double askVolume = 0.0;
    double bidVolume = 0.0;
    var length = bids.length > asks.length ? bids.length : asks.length;
    return vertical
        ? buildVertical(context, vertical)
        : Table(
            columnWidths: {1: FlexColumnWidth(0.01)},
            children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              tr('orderbook_amount_label').toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.overline.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                            ),
                            Text(
                              tr('orderbook_price_label').toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.overline.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              tr('price_label').toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.overline.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                            ),
                            Text(
                              tr('amount_label').toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.overline.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ] +
                List.generate(
                  length,
                  (i) => TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              userSession.barongSession == ''
                                  ? Navigator.pushNamed(context, '/signInPage')
                                  : showDialog(
                                      context: context,
                                      builder: (context) => ModalWindow(
                                        titleName: tr('place_order'),
                                        content: OrderPlacementScreen(
                                          balances: balances,
                                          isAuthourized: isAuthourized,
                                          userSession: userSession,
                                          onPlaceOrder: onPlaceOrder,
                                          selectedMarket: selectedMarket,
                                          limitSelected: true,
                                          side: orderSide.sell,
                                          price: bids.asMap().containsKey(i)
                                              ? bids.elementAt(i)?.price
                                              : 0.0,
                                          amount: bids.asMap().containsKey(i)
                                              ? bids.elementAt(i)?.amount
                                              : 0.0,
                                        ),
                                      ),
                                    );
                            },
                            child: OrderbookItem(
                              selectedMarket: selectedMarket,
                              widthFactor: orderWidthHelper(
                                  orderbook,
                                  bids.asMap().containsKey(i)
                                      ? bidVolume += bids.elementAt(i).amount
                                      : 0.0),
                              itemSide: orderSide.buy,
                              amount: bids.asMap().containsKey(i)
                                  ? bids.elementAt(i)?.amount
                                  : 0.0,
                              price: bids.asMap().containsKey(i)
                                  ? bids.elementAt(i)?.price
                                  : 0.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              userSession.barongSession == ''
                                  ? Navigator.pushNamed(context, '/signInPage')
                                  : showDialog(
                                      context: context,
                                      builder: (context) => ModalWindow(
                                        titleName: tr('place_order'),
                                        content: OrderPlacementScreen(
                                          balances: balances,
                                          isAuthourized: isAuthourized,
                                          onPlaceOrder: onPlaceOrder,
                                          userSession: userSession,
                                          selectedMarket: selectedMarket,
                                          limitSelected: true,
                                          side: orderSide.buy,
                                          price: asks.asMap().containsKey(i)
                                              ? asks.elementAt(i)?.price
                                              : 0.0,
                                          amount: asks.asMap().containsKey(i)
                                              ? asks.elementAt(i)?.amount
                                              : 0.0,
                                        ),
                                      ),
                                    );
                            },
                            child: OrderbookItem(
                              selectedMarket: selectedMarket,
                              widthFactor: orderWidthHelper(
                                  orderbook,
                                  asks.asMap().containsKey(i)
                                      ? askVolume += asks.elementAt(i)?.amount
                                      : 0.0),
                              itemSide: orderSide.sell,
                              amount: asks.asMap().containsKey(i)
                                  ? asks.elementAt(i)?.amount
                                  : 0.0,
                              price: asks.asMap().containsKey(i)
                                  ? asks.elementAt(i)?.price
                                  : 0.0,
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
