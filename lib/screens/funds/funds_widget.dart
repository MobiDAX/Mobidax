import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobidax_redux/redux.dart';

import '../../components/spacers.dart';

class FundsPage extends StatelessWidget {
  const FundsPage({
    this.isAuthorized,
    this.onFetchBalance,
    this.balances,
    this.isFundsLoading,
    this.onShowWallet,
  });

  final bool isAuthorized;
  final Function onFetchBalance;
  final List<UserBalanceItemState> balances;
  final bool isFundsLoading;
  final Function(int, String) onShowWallet;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: isFundsLoading && balances.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.primary,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).accentColor,
                ),
              ),
            )
          : RefreshIndicator(
              color: Theme.of(context).accentColor,
              backgroundColor: Theme.of(context).colorScheme.background,
              onRefresh: () async {
                onFetchBalance();
              },
              child: SafeArea(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                  ),
                  itemCount: balances.length,
                  itemBuilder: (context, i) {
                    var item = balances[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                      ),
                      elevation: 8,
                      color: Theme.of(context).colorScheme.primary,
                      child: InkWell(
                        onTap: () {
                          onShowWallet(i, item.currency.id);
                          Navigator.pushNamed(
                            context,
                            '/wallet',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                ),
                                child: CircleAvatar(
                                  maxRadius: 20.0,
                                  backgroundColor: Colors.transparent,
                                  child: item.currency.iconUrl != null
                                      ? item.currency.iconUrl.endsWith(
                                          'svg',
                                        )
                                          ? SvgPicture.network(
                                              item.currency.iconUrl,
                                            )
                                          : Image.network(
                                              item.currency.iconUrl,
                                            )
                                      : Text(
                                          item.currency.symbol,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyText1
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                        ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.currency.name,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                  ),
                                  Text(
                                    item.currency.id.toUpperCase(),
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .caption
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(
                                                0.6,
                                              ),
                                        ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        item.balance.toStringAsFixed(
                                            item.currency.precision),
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .bodyText1
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(
                                            Icons.lock,
                                            size: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(
                                                  0.6,
                                                ),
                                          ),
                                          SpaceW4(),
                                          Text(
                                            "${item.locked.toStringAsFixed(item.currency.precision)}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground
                                                      .withOpacity(
                                                        0.6,
                                                      ),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
