import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:k_chart/flutter_k_chart.dart';
import '../../components/spacers.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';

import '../../components/modal_window.dart';
import '../../components/order_placement_screen.dart';
import '../../components/order_tab_pages.dart';
import '../../components/orderbook.dart';
import '../../components/period_selector.dart';
import '../../components/switch_button.dart';
import '../../components/tabbar_component.dart';
import '../../helpers/color_helper.dart';
import '../../helpers/sizes_helpers.dart';
import '../../utils/theme.dart';
import '../../components/sign_in_or_sign_up.dart';

class ExchangePage extends StatelessWidget {
  const ExchangePage({
    this.onMarketSeletor,
    this.selectedMarket,
    this.onPlaceOrder,
    this.onCancelOrder,
    this.isLoading,
    this.selectedPeriod,
    this.isOrderbook,
    this.isAuthourized,
    this.selectedTabIndex,
    this.onSwitchSelect,
    this.onTabSelect,
    this.onPeriodSelect,
    this.onOrderSelect,
    this.onFetchMore,
    this.cancelAllOrders,
    this.klineState,
    this.marketTrades,
    this.userTrades,
    this.userOrders,
    this.orderbook,
    this.balances,
    this.userSession,
  });

  final Function() onMarketSeletor;
  final Function onOrderSelect;
  final Function onPlaceOrder;
  final Function cancelAllOrders;
  final MarketItemState selectedMarket;
  final bool isLoading;
  final bool isOrderbook;
  final bool isAuthourized;
  final int selectedTabIndex;
  final int selectedPeriod;
  final Function(bool selected) onSwitchSelect;
  final Function(int id) onTabSelect;
  final Function(int period, String selectedMarketName) onPeriodSelect;
  final Function(String barongSession, int orderId) onCancelOrder;
  final Function(int period, String selectedMarketId) onFetchMore;
  final List<KLineEntity> klineState;
  final List<TradeItem> marketTrades;
  final List<TradeItem> userTrades;
  final List<OrderItem> userOrders;
  final OrderbookState orderbook;
  final List<UserBalanceItemState> balances;
  final UserSessionState userSession;

  Widget exchangeTabSelector(int selectedTabIndex, BuildContext context) {
    switch (selectedTabIndex) {
      case 0:
        {
          List<OrderItem> userOrdersWithSelectedMarket = userOrders
              .where((order) => order.market == selectedMarket.id)
              .toList();
          return isAuthourized
              ? isLoading && userOrdersWithSelectedMarket.isEmpty
                  ? const Center(
                      child: SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          userOrdersWithSelectedMarket.length > 1
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          "${tr('locked')} ${selectedMarket.baseUnit.id.toUpperCase()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                        ),
                                        Text(
                                          "${tr('locked')} ${selectedMarket.quoteUnit.id.toUpperCase()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          balances
                                              .firstWhere(
                                                (element) =>
                                                    element.currency.id ==
                                                    selectedMarket.baseUnit.id,
                                              )
                                              .locked
                                              .toStringAsFixed(selectedMarket
                                                  .amountPrecision),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                        ),
                                        Text(
                                          balances
                                              .firstWhere(
                                                (element) =>
                                                    element.currency.id ==
                                                    selectedMarket.quoteUnit.id,
                                              )
                                              .locked
                                              .toStringAsFixed(selectedMarket
                                                  .pricePrecision),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                        ),
                                      ],
                                    ),
                                    exchangeTopButtonTheme(
                                      context,
                                      MaterialButton(
                                        elevation: 8,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryVariant,
                                        child: Text(
                                          tr('cancel_all_button'),
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyText2,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => ModalWindow(
                                              titleName:
                                                  tr('cancel_all_button'),
                                              content: Column(
                                                children: <Widget>[
                                                  Center(
                                                    child: Text(
                                                      tr('cancel_all_sentence') +
                                                          " " +
                                                          selectedMarket.name +
                                                          "?",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary,
                                                          ),
                                                    ),
                                                  ),
                                                  SpaceH8(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      MaterialButton(
                                                        minWidth: displayWidth(
                                                                context) *
                                                            0.2,
                                                        color: Colors.green,
                                                        child: Text(
                                                          tr('cancel_all_orders_yes'),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                        ),
                                                        onPressed: () {
                                                          cancelAllOrders(
                                                              selectedMarket
                                                                  .id);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      MaterialButton(
                                                        minWidth: displayWidth(
                                                                context) *
                                                            0.2,
                                                        color: Colors.red,
                                                        child: Text(
                                                          tr('cancel_all_orders_no'),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          Divider(
                            color: Theme.of(context).colorScheme.primaryVariant,
                          ),
                          OrderTabPageOrders(
                            userOrders: userOrdersWithSelectedMarket,
                            selectedMarket: selectedMarket,
                            userSession: userSession,
                            onCancelOrder: onCancelOrder,
                          ),
                        ],
                      ),
                    )
              : Center(
                  child: SignInOrSignUp(title: tr('to_place_orders')),
                );
        }
      case 1:
        {
          return isAuthourized
              ? isLoading && userTrades.isEmpty
                  ? const Center(
                      child: SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : OrderTabPageTrades(
                      marketTrades: userTrades,
                      selectedMarket: selectedMarket,
                    )
              : Center(child: SignInOrSignUp(title: tr('to_place_trades')));
        }
      case 2:
        {
          return isLoading && marketTrades.isEmpty
              ? const Center(
                  heightFactor: 3.0,
                  child: SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                )
              : OrderTabPageTrades(
                  marketTrades: marketTrades,
                  selectedMarket: selectedMarket,
                );
        }
      default:
        {
          return OrderTabPageTrades(
            marketTrades: marketTrades,
            selectedMarket: selectedMarket,
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    var tabNames = [
      tr('orders_label'),
      tr('trades_label'),
      tr('all_trades_label'),
    ];

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              5,
              10,
              5,
              10,
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: <Widget>[
                exchangeTopButtonTheme(
                  context,
                  MaterialButton(
                    elevation: 8,
                    color: Theme.of(context).colorScheme.primaryVariant,
                    onPressed: onMarketSeletor,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          selectedMarket.name,
                          style: Theme.of(context).primaryTextTheme.bodyText2,
                          textScaleFactor: 1,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
                PeriodSelector(
                  onPeriodSelect: onPeriodSelect,
                  selectedMarketName: selectedMarket.id,
                  selectedPeriod: selectedPeriod,
                ),
                CustomSwitch(
                  selectedText: tr('dropdown_labels_book'),
                  defaultText: tr('dropdown_labels_chart'),
                  selected: this.isOrderbook,
                  onToggle: onSwitchSelect,
                  bgColor: Theme.of(context).colorScheme.background,
                  selectedColor: Theme.of(context).colorScheme.primaryVariant,
                ),
              ],
            ),
          ),
          isOrderbook
              ? Container(
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? displayHeight(context) * 0.5
                          : displayHeight(context) * 0.8,
                  width: displayWidth(context) * 0.42,
                  child: orderbook.bids.isEmpty &&
                          orderbook.asks.isEmpty &&
                          isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : orderbook.bids.isEmpty && orderbook.asks.isEmpty
                          ? Center(
                              child: Text(
                                'There\'s no data to show',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                              ),
                            )
                          : Scrollbar(
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Orderbook(
                                  balances: balances,
                                  isAuthourized: isAuthourized,
                                  userSession: userSession,
                                  orderbook: orderbook,
                                  selectedMarket: selectedMarket,
                                  onPlaceOrder: onPlaceOrder,
                                ),
                              ),
                            ),
                )
              : Container(
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? displayHeight(context) * 0.5
                          : displayHeight(context) * 0.8,
                  child: isLoading && klineState.isEmpty
                      ? const Center(
                          child: SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : KChartWidget(
                          klineState, // Required，Data must be an ordered list，(history=>now)
                          isLine:
                              false, // Decide whether it is k-line or time-sharing
                          mainState:
                              MainState.NONE, // Decide what the main view shows
                          secondaryState: SecondaryState
                              .NONE, // Decide what the sub view shows
                          fixedLength: selectedMarket.pricePrecision,
                          flingTime: 300000, // Displayed decimal precision
                          timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                          onLoadMore: (bool a) {
                            if (!a) {
                              onFetchMore(
                                selectedPeriod,
                                selectedMarket.id,
                              );
                            }
                          }, // Called when the data scrolls to the end. When a is true, it means the user is pulled to the end of the right side of the data. When a
                          // is false, it means the user is pulled to the end of the left side of the data.
                          maDayList: [
                            5,
                            10,
                            20
                          ], // Display of MA,This parameter must be equal to DataUtil.calculate‘s maDayList
                          bgColor: [
                            Theme.of(context).colorScheme.background,
                            Theme.of(context).colorScheme.background
                          ], // The background color of the chart is gradient
                          isChinese: false, // Graphic language
                          isOnDrag:
                              (isDrag) {}, // true is on Drag.Don't load data while Draging.
                        ),
                ),
          Material(
            elevation: 4,
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: displayWidth(context) * 0.25,
                    child: MaterialButton(
                      color: Colors.green,
                      onPressed: () {
                        userSession.barongSession == ""
                            ? Navigator.pushNamed(context, '/signInPage')
                            : showDialog(
                                context: context,
                                builder: (context) => ModalWindow(
                                  titleName: tr('place_order'),
                                  content: OrderPlacementScreen(
                                    balances: balances,
                                    isAuthourized: isAuthourized,
                                    userSession: userSession,
                                    side: orderSide.buy,
                                    selectedMarket: selectedMarket,
                                    onPlaceOrder: onPlaceOrder,
                                  ),
                                ),
                              );
                      },
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          tr('buy_button').toUpperCase(),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 90.0,
                        child: Text(
                          tr('last_market_price'),
                          overflow: TextOverflow.fade,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            selectedMarket.ticker.last
                                .toStringAsFixed(selectedMarket.pricePrecision),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            '${selectedMarket.ticker.priceChangePercent}',
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: colorHelper(
                                    selectedMarket.ticker.priceChangePercent,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: displayWidth(context) * 0.25,
                    child: MaterialButton(
                      color: Colors.red,
                      onPressed: () {
                        userSession.barongSession == ""
                            ? Navigator.pushNamed(context, '/signInPage')
                            : showDialog(
                                context: context,
                                builder: (context) => ModalWindow(
                                  titleName: tr('place_order'),
                                  content: OrderPlacementScreen(
                                    balances: balances,
                                    isAuthourized: isAuthourized,
                                    userSession: userSession,
                                    side: orderSide.sell,
                                    selectedMarket: selectedMarket,
                                    onPlaceOrder: onPlaceOrder,
                                  ),
                                ),
                              );
                      },
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          tr('sell_button').toUpperCase(),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              TabBarComp(
                tabNames: tabNames,
                selectedTabIndex: selectedTabIndex,
                onTabSelect: onTabSelect,
              ),
              exchangeTabSelector(
                selectedTabIndex,
                context,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
