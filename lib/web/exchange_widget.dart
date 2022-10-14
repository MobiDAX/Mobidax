import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:mobidax/components/order_placement_screen_with_button.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';
import 'package:webviewx/webviewx.dart';

import '../components/modal_window.dart';
import '../components/order_placement_screen.dart';
import '../components/order_tab_pages.dart';
import '../components/orderbook.dart';
import '../components/period_selector.dart';
import '../helpers/color_helper.dart';
import '../helpers/sizes_helpers.dart';
import '../helpers/volume_helper.dart';
import '../screens/markets/markets_connector.dart';
import '../utils/theme.dart';
import '../components/sign_in_or_sign_up.dart';

class WebExchangePage extends StatefulWidget {
  const WebExchangePage({
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

  final Function onMarketSeletor;
  final Function onOrderSelect;
  final Function onPlaceOrder;
  final Function(String market) cancelAllOrders;
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

  @override
  _WebExchangePageState createState() => _WebExchangePageState();
}

enum ViewValue { tradingView, kChart }

class _WebExchangePageState extends State<WebExchangePage> {
  bool userTrades = false;
  bool sellSelected = false;
  WebViewXController webviewController;
  ViewValue _character = ViewValue.kChart;

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMarket.id != oldWidget.selectedMarket.id &&
        _character == ViewValue.tradingView) {
      webviewController.loadContent(
        'https://trade.mobidax.io/tradingview/?id=${widget.selectedMarket.id}&name=${widget.selectedMarket.baseUnit.id.toUpperCase()}-${widget.selectedMarket.quoteUnit.id.toUpperCase()}&lang=en&quote_unit=${widget.selectedMarket.quoteUnit.id}',
        SourceType.URL,
      );
    }
  }

  Widget myTradesBox(context) {
    return exchangeBoxWrapper(
      Container(
        height: displayHeight(context) * 0.36,
        child: widget.isLoading && widget.userTrades.isEmpty
            ? const Center(
                heightFactor: 3.0,
                child: SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ),
              )
            : AllTrades(
                marketTrades: widget.userTrades,
                selectedMarket: widget.selectedMarket,
                selectedPrecision: widget.selectedMarket.amountPrecision,
              ),
      ),
      Align(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr("${tr('my')} ${tr('trades_label')}").toUpperCase(),
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
      context,
    );
  }

  Widget allTradesBox(context) {
    return exchangeBoxWrapper(
      Container(
        height: displayHeight(context) * 0.36,
        child: widget.isLoading && widget.marketTrades.isEmpty
            ? const Center(
                heightFactor: 3.0,
                child: SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ),
              )
            : AllTrades(
                marketTrades: widget.marketTrades,
                selectedMarket: widget.selectedMarket,
                selectedPrecision: widget.selectedMarket.amountPrecision,
              ),
      ),
      Align(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr('all_trades_label').toUpperCase(),
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
      context,
    );
  }

  Widget orderBook(context) {
    return Container(
      height: displayWidth(context) > 1200
          ? displayHeight(context) * 0.99
          : displayHeight(context) * 0.56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(
          4.0,
        ),
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 46.0,
              padding: const EdgeInsets.fromLTRB(
                12.0,
                6.0,
                12.0,
                6.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr('dropdown_labels_book').toUpperCase(),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
                ),
              ),
              child: Container(
                height: displayWidth(context) > 1200
                    ? displayHeight(context) * 0.98
                    : displayHeight(context) * 0.47,
                child: widget.orderbook.bids.isEmpty &&
                        widget.orderbook.asks.isEmpty &&
                        widget.isLoading
                    ? const Center(
                        child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : widget.orderbook.bids.isEmpty &&
                            widget.orderbook.asks.isEmpty
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
                            child: Orderbook(
                              isAuthourized: widget.isAuthourized,
                              balances: widget.balances,
                              userSession: widget.userSession,
                              orderbook: widget.orderbook,
                              selectedMarket: widget.selectedMarket,
                              onPlaceOrder: widget.onPlaceOrder,
                              vertical:
                                  displayWidth(context) > 1200 ? true : false,
                            ),
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<OrderItem> userOrdersWithSelectedMarket = widget.userOrders
        .where((order) => order.market == widget.selectedMarket.id)
        .toList();
    return Container(
      color: Theme.of(context).colorScheme.primaryVariant,
      child: StaggeredGridView.count(
        padding: const EdgeInsets.all(
          4.0,
        ),
        primary: false,
        crossAxisCount: 10,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        physics: displayWidth(context) < 1200
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: <Widget>[
          exchangeBoxWrapper(
            isDesktop(context)
                ? Container(
                    height: displayHeight(context) * 0.48,
                    child: _character == ViewValue.tradingView
                        ? WebViewX(
                            onWebViewCreated: (controller) =>
                                webviewController = controller,
                            initialContent:
                                'https://${GraphQLClientAPI.gqlServerHost}/tradingview/?id=${widget.selectedMarket.id}&name=${widget.selectedMarket.baseUnit.id.toUpperCase()}-${widget.selectedMarket.quoteUnit.id.toUpperCase()}&lang=en&quote_unit=${widget.selectedMarket.quoteUnit.id}',
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                            ),
                            child: KChartWidget(
                              widget
                                  .klineState, // Required，Data must be an ordered list，(history=>now)
                              isLine:
                                  false, // Decide whether it is k-line or time-sharing
                              mainState: MainState
                                  .NONE, // Decide what the main view shows
                              secondaryState: SecondaryState
                                  .NONE, // Decide what the sub view shows
                              fixedLength: widget.selectedMarket.pricePrecision,
                              timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                              onLoadMore: (bool a) {
                                if (!a) {
                                  widget.onFetchMore(widget.selectedPeriod,
                                      widget.selectedMarket.id);
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
                              ], //// The background color of the chart is gradient
                              isChinese: false, // Graphic language
                              isOnDrag:
                                  (isDrag) {}, // true is on Drag.Don't load data while Draging.
                            ),
                          ),
                  )
                : Container(
                    height: displayHeight(context) * 0.48,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                    ),
                    child: widget.isLoading && widget.klineState.isEmpty
                        ? const Center(
                            child: SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        : KChartWidget(
                            widget
                                .klineState, // Required，Data must be an ordered list，(history=>now)
                            isLine:
                                false, // Decide whether it is k-line or time-sharing
                            mainState: MainState
                                .NONE, // Decide what the main view shows
                            secondaryState: SecondaryState
                                .NONE, // Decide what the sub view shows
                            fixedLength: widget.selectedMarket.pricePrecision,
                            timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                            onLoadMore: (bool a) {
                              if (!a) {
                                widget.onFetchMore(widget.selectedPeriod,
                                    widget.selectedMarket.id);
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
                            ], //// The background color of the chart is gradient
                            isChinese: false, // Graphic language
                            isOnDrag:
                                (isDrag) {}, // true is on Drag.Don't load data while Draging.
                          ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 16.0,
                      backgroundColor: Colors.transparent,
                      child: widget.selectedMarket.baseUnit.iconUrl != null
                          ? widget.selectedMarket.baseUnit.iconUrl
                                  .endsWith('svg')
                              ? SvgPicture.network(
                                  widget.selectedMarket.baseUnit.iconUrl,
                                )
                              : Image.network(
                                  widget.selectedMarket.baseUnit.iconUrl,
                                )
                          : Text(
                              widget.selectedMarket.baseUnit.symbol,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .copyWith(fontSize: 16.0),
                            ),
                    ),
                    Icon(Icons.swap_horiz,
                        size: 30,
                        color: Theme.of(context).colorScheme.primaryVariant),
                    CircleAvatar(
                      maxRadius: 16.0,
                      backgroundColor: Colors.transparent,
                      child: widget.selectedMarket.baseUnit.iconUrl != null
                          ? widget.selectedMarket.baseUnit.iconUrl
                                  .endsWith('svg')
                              ? SvgPicture.network(
                                  widget.selectedMarket.quoteUnit.iconUrl,
                                )
                              : Image.network(
                                  widget.selectedMarket.quoteUnit.iconUrl,
                                )
                          : Text(
                              widget.selectedMarket.baseUnit.symbol,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .copyWith(fontSize: 16.0),
                            ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      widget.selectedMarket.name.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      '${widget.selectedMarket.baseUnit.name} / ${widget.selectedMarket.quoteUnit.name}',
                      style: Theme.of(context).textTheme.overline.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.8),
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${widget.selectedMarket.ticker.last.toStringAsFixed(widget.selectedMarket.pricePrecision)}',
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: colorHelper(
                              widget.selectedMarket.ticker.priceChangePercent),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      '${widget.selectedMarket.quoteUnit.symbol} ${widget.selectedMarket.ticker.last.toStringAsFixed(widget.selectedMarket.pricePrecision)}',
                      style: Theme.of(context).textTheme.overline.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.8),
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${widget.selectedMarket.ticker.priceChangePercent}',
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: colorHelper(
                              widget.selectedMarket.ticker.priceChangePercent),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      "${tr('price_change_24h')}",
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.overline.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.8),
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "${volumeHelper(widget.selectedMarket.ticker.volume, widget.selectedMarket.name.split('/')[1])}",
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      "${tr('volume_24h')}",
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.overline.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.8),
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                isDesktop(context)
                    ? Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _character = ViewValue.tradingView;
                                refresh();
                              },
                              icon: Icon(
                                Icons.cloud_circle,
                                color: _character == ViewValue.tradingView
                                    ? Theme.of(context).canvasColor
                                    : Theme.of(context).unselectedWidgetColor,
                                size: 18,
                              ),
                              tooltip: 'Trading View',
                              iconSize: 18,
                            ),
                            IconButton(
                              onPressed: () {
                                _character = ViewValue.kChart;
                                refresh();
                              },
                              icon: Icon(
                                Icons.bar_chart_outlined,
                                color: _character == ViewValue.kChart
                                    ? Theme.of(context).canvasColor
                                    : Theme.of(context).unselectedWidgetColor,
                                size: 18,
                              ),
                              tooltip: 'Original',
                            ),
                            _character == ViewValue.kChart
                                ? Container(
                                    child: PeriodSelector(
                                      onPeriodSelect: widget.onPeriodSelect,
                                      selectedMarketName:
                                          widget.selectedMarket.id,
                                      selectedPeriod: widget.selectedPeriod,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : Container(
                        child: PeriodSelector(
                          onPeriodSelect: widget.onPeriodSelect,
                          selectedMarketName: widget.selectedMarket.id,
                          selectedPeriod: widget.selectedPeriod,
                        ),
                      ),
              ],
            ),
            context,
            height: displayHeight(context) * 0.56,
          ),
          orderBook(context),
          exchangeBoxWrapper(
              Container(
                height: displayHeight(context) * 0.495,
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OrderPlacementScreenWithButton(
                        isAuthourized: widget.isAuthourized,
                        switchBgColor: Theme.of(context).colorScheme.background,
                        balances: widget.balances,
                        userSession: widget.userSession,
                        selectedMarket: widget.selectedMarket,
                        onPlaceOrder: widget.onPlaceOrder,
                        popAfterOrder: false,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr('order_form').toUpperCase(),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              context,
              height: displayHeight(context) * 0.56),
          exchangeBoxWrapper(
              Container(
                  height: displayHeight(context) * 0.36,
                  child: MarketPageConnector(true, (item) {})),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tr('markets').toUpperCase(),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              context),
          exchangeBoxWrapper(
            Container(
              height: displayHeight(context) * 0.36,
              child: widget.isAuthourized
                  ? widget.isLoading && userOrdersWithSelectedMarket.isEmpty
                      ? Center(
                          child: SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: UserOrders(
                            userOrders: userOrdersWithSelectedMarket,
                            selectedMarket: widget.selectedMarket,
                            userSession: widget.userSession,
                            onCancelOrder: widget.onCancelOrder,
                          ),
                        )
                  : Center(child: SignInOrSignUp(title: tr('to_place_orders'))),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr('orders_label').toUpperCase(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                ),
                exchangeTopButtonTheme(
                  context,
                  MaterialButton(
                    elevation: 8,
                    color: systemRed,
                    disabledColor: systemRed.withOpacity(0.3),
                    disabledElevation: 0,
                    child: Text(
                      tr('cancel_all_button'),
                      style: Theme.of(context).primaryTextTheme.bodyText2,
                    ),
                    onPressed: widget.isAuthourized &&
                            userOrdersWithSelectedMarket.isNotEmpty
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) => ModalWindow(
                                    titleName: tr('cancel_all_button'),
                                    content: Column(
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            tr('cancel_all_sentence') +
                                                ' ' +
                                                widget.selectedMarket.name +
                                                '?',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16.0,
                                        ),
                                        Container(
                                          width: 180.0,
                                          child: Flex(
                                            direction: Axis.horizontal,
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: MaterialButton(
                                                  color: Colors.green,
                                                  child: Text(
                                                    tr('cancel_all_orders_yes'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  onPressed: () {
                                                    widget.cancelAllOrders(
                                                        widget
                                                            .selectedMarket.id);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 32.0,
                                              ),
                                              Expanded(
                                                child: MaterialButton(
                                                  color: systemRed,
                                                  child: Text(
                                                    tr('cancel_all_orders_no'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )));
                          }
                        : null,
                  ),
                )
              ],
            ),
            context,
          ),
          myTradesBox(context),
          allTradesBox(context),
        ],
        staggeredTiles: displayWidth(context) > 1200
            ? <StaggeredTile>[
                const StaggeredTile.fit(6),
                const StaggeredTile.fit(2),
                const StaggeredTile.fit(2),
                const StaggeredTile.fit(2),
                const StaggeredTile.fit(2),
                const StaggeredTile.fit(2),
                const StaggeredTile.fit(2),
              ]
            : displayWidth(context) > 900
                ? <StaggeredTile>[
                    const StaggeredTile.fit(7),
                    const StaggeredTile.fit(3),
                    const StaggeredTile.fit(3),
                    const StaggeredTile.fit(3),
                    const StaggeredTile.fit(4),
                    const StaggeredTile.fit(3),
                    const StaggeredTile.fit(4),
                  ]
                : <StaggeredTile>[
                    const StaggeredTile.fit(7),
                    const StaggeredTile.fit(3),
                    const StaggeredTile.fit(3),
                    const StaggeredTile.fit(3),
                    const StaggeredTile.fit(3),
                    const StaggeredTile.fit(3),
                  ],
      ),
    );
  }
}

Widget exchangeBoxWrapper(Widget content, Widget title, BuildContext context,
    {double height}) {
  return Container(
    height: height ?? displayHeight(context) * 0.424,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(
        4.0,
      ),
    ),
    child: Column(
      children: <Widget>[
        Container(
            height: 46.0,
            padding: const EdgeInsets.fromLTRB(
              12.0,
              6.0,
              12.0,
              6.0,
            ),
            child: title),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
            ),
          ),
          child: content,
        )
      ],
    ),
  );
}
