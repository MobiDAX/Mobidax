import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';

import '../../components/bottom_navigation.dart';
import '../../components/spacers.dart';
import '../../helpers/color_helper.dart';
import '../../helpers/volume_helper.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({
    this.marketsLoading,
    this.markets,
    this.onBuild,
    this.fromNav,
    this.selectTab,
    this.onSelectFavourite,
    this.onSearchBoxChanged,
    this.onTapMarket,
    this.selectedMarket,
    this.tickerUpdate,
    Key key,
  }) : super(key: key);

  final bool marketsLoading;
  final bool fromNav;
  final MarketItemState selectedMarket;
  final Function(TabItem tabItem) selectTab;
  final List<MarketItemState> markets;
  final Function() onBuild;
  final Function(MarketItemState item) onSelectFavourite;
  final Function(String text) onSearchBoxChanged;
  final Function(MarketItemState item) onTapMarket;
  final Function(TickerState ticker, String marketId) tickerUpdate;

  @override
  Widget build(BuildContext context) {
    return marketsLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.primary,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).accentColor,
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.only(
              top: 2.0,
            ),
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: RefreshIndicator(
                    color: Theme.of(context).accentColor,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onRefresh: () => onBuild(),
                    child: ListView.builder(
                      itemCount: markets.length,
                      itemBuilder: (context, i) {
                        var item = markets[i];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                          ),
                          elevation: 8,
                          color: Theme.of(context).colorScheme.primary,
                          child: InkWell(
                            onTap: () async {
                              await onTapMarket(item);
                              selectTab(
                                TabItem.exchange,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  IconButton(
                                    iconSize: 16.0,
                                    alignment: Alignment.center,
                                    onPressed: () {
                                      onSelectFavourite(item);
                                    },
                                    icon: Icon(
                                      item.isFavourite
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item.name,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .bodyText2
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        volumeHelper(item.ticker.volume,
                                                item.name.split('/')[1])
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            item.ticker.last.toStringAsFixed(
                                                item.pricePrecision),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            item.ticker.priceChangePercent,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                  color: colorHelper(
                                                    item.ticker
                                                        .priceChangePercent,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SpaceW2(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
