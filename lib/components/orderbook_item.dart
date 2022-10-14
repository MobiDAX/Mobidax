import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/markets/markets_state.dart';
import 'package:mobidax_redux/types.dart';

import '../utils/theme.dart';

class OrderbookItem extends StatelessWidget {
  const OrderbookItem({
    this.widthFactor,
    this.selectedMarket,
    this.itemSide,
    this.price,
    this.amount,
    this.vertical = false,
  });

  final double widthFactor;
  final orderSide itemSide;
  final double amount;
  final double price;
  final bool vertical;
  final MarketItemState selectedMarket;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.0,
      padding: const EdgeInsets.only(
        bottom: 2.0,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: vertical
                ? Alignment.bottomLeft
                : itemSide == orderSide.buy
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
            child: FractionallySizedBox(
              widthFactor: widthFactor,
              child: Container(
                color: itemSide == orderSide.buy ? systemGreen : systemRed,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                  child: Text(
                    vertical
                        ? price.toStringAsFixed(selectedMarket.pricePrecision)
                        : itemSide == orderSide.buy
                            ? amount != 0.0
                                ? amount.toStringAsFixed(
                                    selectedMarket.amountPrecision,
                                  )
                                : ''
                            : price != 0.0
                                ? price.toStringAsFixed(
                                    selectedMarket.pricePrecision,
                                  )
                                : '',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
                Center(
                  child: Text(
                    vertical
                        ? amount.toStringAsFixed(selectedMarket.amountPrecision)
                        : itemSide == orderSide.buy
                            ? price != 0.0
                                ? price.toStringAsFixed(
                                    selectedMarket.pricePrecision,
                                  )
                                : ''
                            : amount != 0.0
                                ? amount.toStringAsFixed(
                                    selectedMarket.amountPrecision,
                                  )
                                : '',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
