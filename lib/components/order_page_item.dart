import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helpers/color_helper.dart';

class OrderPageItem extends StatelessWidget {
  const OrderPageItem({
    this.option,
    this.firstColumnTitle,
    this.firstColumnValue,
    this.secondColumnTitle,
    this.secondColumnValue,
    this.thirdColumnTitle,
    this.thirdColumnValue,
    this.icon,
    this.onIconTap,
  });

  final String option;
  final String firstColumnTitle;
  final String firstColumnValue;
  final String secondColumnTitle;
  final String secondColumnValue;
  final String thirdColumnTitle;
  final String thirdColumnValue;
  final Icon icon;
  final VoidCallback onIconTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
      ),
      elevation: 0,
      color: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.all(
        2.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          0.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(
                10,
              ),
              child: Center(
                child: Text(
                  tr(option).toUpperCase(),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: takerTypeColorHelper(option),
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
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                Text(
                  firstColumnValue,
                  style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
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
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                Text(
                  secondColumnValue,
                  style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ],
            ),
            thirdColumnTitle != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        thirdColumnTitle,
                        style: Theme.of(context).primaryTextTheme.overline,
                      ),
                      Text(
                        thirdColumnValue,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .caption
                            .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            IconButton(
              iconSize: 25.0,
              icon: Icon(
                icon.icon,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onIconTap,
            ),
          ],
        ),
      ),
    );
  }
}
