import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../components/account_screen_inputs.dart';
import '../../components/spacers.dart';
import '../../components/tabbar_component.dart';
import '../../components/wallet_history_item.dart';
import '../../components/wallet_tab_pages.dart';
import '../../helpers/error_notifier.dart';
import '../../helpers/sizes_helpers.dart';

class FundsPageWeb extends StatefulWidget {
  const FundsPageWeb({
    this.isAuthorized,
    this.onFetchBalance,
    this.balances,
    this.deposits,
    this.withdrawals,
    this.beneficiaries,
    this.selectedBeneficiary,
    this.user,
    this.isFundsLoading,
    this.selectedCardIndex,
    this.onShowWallet,
  });

  final bool isAuthorized;
  final Function onFetchBalance;
  final List<UserBalanceItemState> balances;
  final bool isFundsLoading;
  final Function(int, String) onShowWallet;
  final int selectedCardIndex;
  final List<DepositItem> deposits;
  final List<WithdrawalItem> withdrawals;
  final List<Beneficiary> beneficiaries;
  final Beneficiary selectedBeneficiary;
  final UserState user;

  @override
  _FundsPageWebState createState() => _FundsPageWebState();
}

class _FundsPageWebState extends State<FundsPageWeb> {
  bool depositSelected = true;
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    var selectedItem = widget.balances[widget.selectedCardIndex];
    var tabNames = [
      tr('deposit'),
      tr('withdrawal'),
    ];
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 54.0,
        ),
        constraints: const BoxConstraints(
          maxWidth: 900,
        ),
        child: widget.isFundsLoading && widget.balances.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                ),
              )
            : RefreshIndicator(
                color: Theme.of(context).accentColor,
                backgroundColor: Theme.of(context).colorScheme.background,
                onRefresh: () async {
                  widget.onFetchBalance();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 280.0,
                      ),
                      child: ListView.builder(
                        itemCount: widget.balances.length,
                        itemBuilder: (context, i) {
                          var item = widget.balances[i];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 8,
                            color: i == widget.selectedCardIndex
                                ? Theme.of(context).colorScheme.primaryVariant
                                : Theme.of(context).colorScheme.primary,
                            child: InkWell(
                              onTap: () {
                                widget.onShowWallet(i, item.currency.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: CircleAvatar(
                                        maxRadius: 20.0,
                                        backgroundColor: Colors.transparent,
                                        child: item.currency.iconUrl != null
                                            ? item.currency.iconUrl
                                                    .endsWith('svg')
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    .withOpacity(0.6),
                                              ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.lock,
                                                  size: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground
                                                      .withOpacity(0.6),
                                                ),
                                                SpaceW4(),
                                                Text(
                                                  '${item.locked}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground
                                                            .withOpacity(0.6),
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
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4.0,
                        left: 8.0,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 480.0,
                                ),
                                padding: const EdgeInsets.all(
                                  28.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                    colors: [
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryVariant
                                          .withOpacity(0.8),
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryVariant
                                          .withOpacity(0.5),
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryVariant
                                          .withOpacity(0.3),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        CircleAvatar(
                                          maxRadius: 20.0,
                                          backgroundColor: Colors.transparent,
                                          child: selectedItem
                                                      .currency.iconUrl !=
                                                  null
                                              ? selectedItem.currency.iconUrl
                                                      .endsWith('svg')
                                                  ? SvgPicture.network(
                                                      selectedItem
                                                          .currency.iconUrl,
                                                    )
                                                  : Image.network(
                                                      selectedItem
                                                          .currency.iconUrl,
                                                    )
                                              : Text(
                                                  selectedItem.currency.symbol,
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        fontSize: 20.0,
                                                      ),
                                                ),
                                        ),
                                        SpaceW10(),
                                        Text(
                                          selectedItem.currency.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SpaceH16(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "${tr('locked')} ${tr('balance')}",
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .caption
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary
                                                          .withOpacity(0.8),
                                                    ),
                                              ),
                                              Text(
                                                "${tr('total_label')} ${tr('balance')}",
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SpaceH16(),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                selectedItem.locked.toString() +
                                                    " " +
                                                    selectedItem.currency.id
                                                        .toUpperCase(),
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .caption
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary
                                                          .withOpacity(0.8),
                                                    ),
                                              ),
                                              Text(
                                                selectedItem.balance
                                                        .toStringAsFixed(
                                                            selectedItem
                                                                .currency
                                                                .precision) +
                                                    " " +
                                                    selectedItem.currency.id
                                                        .toUpperCase(),
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SpaceH16(),
                                  ],
                                ),
                              ),
                              SpaceH16(),
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 480.0,
                                  minWidth: 480.0,
                                ),
                                child: TabBarComp(
                                  tabNames: tabNames,
                                  selectedTabIndex: selectedTab,
                                  onTabSelect: (index) {
                                    setState(() {
                                      selectedTab = index;
                                      depositSelected =
                                          index == 0 ? true : false;
                                    });
                                  },
                                ),
                              ),
                              SpaceH8(),
                              depositSelected
                                  ? ClipRRect(
                                      child: Stack(
                                        children: [
                                          Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 480.0,
                                              minWidth: 480.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                8.0,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(
                                              32.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                selectedItem.currency.type ==
                                                        "fiat"
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            tr('bank_name_label'),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption
                                                                .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primaryVariant,
                                                                ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 4,
                                                            ),
                                                            child: CopyField(
                                                              text: tr(
                                                                  'bank_name'),
                                                            ),
                                                          ),
                                                          Text(
                                                            tr('bank_account_label'),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption
                                                                .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primaryVariant,
                                                                ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 4,
                                                            ),
                                                            child: CopyField(
                                                              text: tr(
                                                                  'bank_account'),
                                                            ),
                                                          ),
                                                          Text(
                                                            tr('bank_account_number_label'),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption
                                                                .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primaryVariant,
                                                                ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 4,
                                                            ),
                                                            child: CopyField(
                                                              text: tr(
                                                                  'bank_account_number'),
                                                            ),
                                                          ),
                                                          Text(
                                                            tr('reference_number_label'),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption
                                                                .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primaryVariant,
                                                                ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              vertical: 4,
                                                            ),
                                                            child: CopyField(
                                                              text: widget
                                                                  .user.uid,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : selectedItem.currency
                                                                    .depositAddress ==
                                                                "" ||
                                                            selectedItem
                                                                    .currency
                                                                    .depositAddress ==
                                                                null
                                                        ? Container(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            constraints:
                                                                const BoxConstraints(
                                                              minWidth: 480.0,
                                                              maxWidth: 480.0,
                                                            ),
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  Theme.of(
                                                                          context)
                                                                      .accentColor,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 10,
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    child:
                                                                        QrImage(
                                                                      data: selectedItem
                                                                              .currency
                                                                              .depositAddress ??
                                                                          "",
                                                                      gapless:
                                                                          true,
                                                                      size: 125,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SpaceH10(),
                                                                Text(
                                                                  tr('deposit_wallet_address'),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText2
                                                                      .copyWith(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .onPrimary),
                                                                ),
                                                                SpaceH5(),
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                    12.0,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      8,
                                                                    ),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      width: 1,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primaryVariant,
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    selectedItem
                                                                            .currency
                                                                            .depositAddress ??
                                                                        "",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .primaryTextTheme
                                                                        .caption
                                                                        .copyWith(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .onBackground,
                                                                        ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                SpaceH8(),
                                                                ElevatedButton(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        tr('copy_label'),
                                                                        style: Theme.of(context)
                                                                            .primaryTextTheme
                                                                            .bodyText1
                                                                            .copyWith(
                                                                              color: Theme.of(context).colorScheme.onSecondary,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Clipboard
                                                                        .setData(
                                                                      ClipboardData(
                                                                        text: selectedItem.currency.depositAddress ??
                                                                            "",
                                                                      ),
                                                                    );
                                                                    SnackBarNotifier
                                                                        .createSnackBar(
                                                                      tr('copied'),
                                                                      context,
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                              ],
                                            ),
                                          ),
                                          widget
                                                  .balances[
                                                      widget.selectedCardIndex]
                                                  .currency
                                                  .depositEnabled
                                              ? const SizedBox()
                                              : BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX: 10.0,
                                                    sigmaY: 10.0,
                                                  ),
                                                  child: Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                      minWidth: 480.0,
                                                      maxWidth: 480.0,
                                                    ),
                                                    height: isDesktop(context)
                                                        ? 300
                                                        : displayHeight(
                                                                context) *
                                                            0.5,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.lock,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primaryVariant,
                                                            size: 48.0,
                                                          ),
                                                          SpaceH16(),
                                                          Text(
                                                            tr('deposit_disabled'),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(
                                        32.0,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 480.0,
                                        maxWidth: 480.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                      child: WalletPageTabWithdrawal(
                                        balances: widget
                                            .balances[widget.selectedCardIndex],
                                        selectedBeneficiary:
                                            widget.selectedBeneficiary,
                                        user: widget.user,
                                        onWithdrawal: () {
                                          Navigator.of(context)
                                              .pushNamed("/withdrawal");
                                        },
                                        onAddBeneficiary: () {
                                          Navigator.of(context)
                                              .pushNamed("/createBeneficiary");
                                        },
                                        onWithdrawalHistory: null,
                                        currency: widget
                                            .balances[widget.selectedCardIndex]
                                            .currency,
                                        beneficiaries: widget.beneficiaries,
                                      ),
                                    ),
                              SpaceH24(),
                              Container(
                                constraints: const BoxConstraints(
                                  minWidth: 480.0,
                                  maxWidth: 480.0,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(
                                    8.0,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 36.0,
                                        left: 36.0,
                                        top: 16.0,
                                        bottom: 16.0,
                                      ),
                                      child: Text(
                                        depositSelected
                                            ? tr('deposit_history')
                                            : tr('withdrawal_history'),
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline6
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                      ),
                                    ),
                                    Column(
                                      children: depositSelected
                                          ? widget.deposits.isNotEmpty
                                              ? List.generate(
                                                  widget.deposits.length,
                                                  (i) => WalletHistoryItem(
                                                    status:
                                                        "${widget.deposits[i].state[0].toUpperCase()}${widget.deposits[i].state.substring(1)}",
                                                    amount: widget
                                                        .deposits[i].amount,
                                                    timestamp: int.parse(widget
                                                        .deposits[i].createdAt),
                                                    transactionId: widget
                                                            .deposits[i]
                                                            .blockchainTXID ??
                                                        "",
                                                    currency: widget
                                                        .deposits[i].currency
                                                        .toUpperCase(),
                                                    fee: widget.deposits[i].fee,
                                                    explorerTransaction: widget
                                                        .balances[widget
                                                            .selectedCardIndex]
                                                        .currency
                                                        .explorerTransaction,
                                                    modalTitle:
                                                        tr('deposit_info'),
                                                    isWithdrawal: false,
                                                  ),
                                                )
                                              : [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 16.0,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        tr('no_items'),
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                          : widget.withdrawals.isNotEmpty
                                              ? List.generate(
                                                  widget.withdrawals.length,
                                                  (i) => WalletHistoryItem(
                                                    status:
                                                        "${widget.withdrawals[i].state[0].toUpperCase()}${widget.withdrawals[i].state.substring(1)}",
                                                    amount: widget
                                                        .withdrawals[i].amount,
                                                    timestamp: widget
                                                        .withdrawals[i]
                                                        .createdAt,
                                                    transactionId: widget
                                                            .withdrawals[i]
                                                            .blockchainTXID ??
                                                        "",
                                                    currency: widget
                                                        .withdrawals[i].currency
                                                        .toUpperCase(),
                                                    fee: widget
                                                        .withdrawals[i].fee,
                                                    explorerTransaction: widget
                                                        .balances[widget
                                                            .selectedCardIndex]
                                                        .currency
                                                        .explorerTransaction,
                                                    modalTitle: tr(
                                                      'withdraw_info',
                                                    ),
                                                    isWithdrawal: true,
                                                  ),
                                                )
                                              : [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 16.0,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        tr('no_items'),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
