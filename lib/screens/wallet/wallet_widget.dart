import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mobidax_redux/redux.dart';

import '../../components/spacers.dart';
import '../../components/tabbar_component.dart';
import '../../components/wallet_tab_pages.dart';
import '../../helpers/sizes_helpers.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({
    this.onTabSelect,
    this.selectedTabIndex,
    this.onWithdrawal,
    this.onAddBeneficiary,
    this.onWithdrawalHistory,
    this.onDepositHistory,
    this.balances,
    this.user,
    this.beneficiaries,
    this.selectedBeneficiary,
    this.selectedCardIndex,
    this.onCardSelect,
  });

  final Function onTabSelect;
  final int selectedTabIndex;
  final int selectedCardIndex;
  final Function onWithdrawal;
  final UserState user;
  final Function onAddBeneficiary;
  final Function() onDepositHistory;
  final Function() onWithdrawalHistory;
  final Function(int, String) onCardSelect;
  final List<UserBalanceItemState> balances;
  final List<Beneficiary> beneficiaries;
  final Beneficiary selectedBeneficiary;

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Widget walletPageTabSelector(
      int selectedTabIndex,
      CurrencyItemState selectedCurrency,
      Beneficiary selectedBeneficiary,
      UserState user) {
    switch (selectedTabIndex) {
      case 0:
        {
          return WalletPageTabDeposit(
            onDepositHistory: widget.onDepositHistory,
            selectedCurrency: selectedCurrency,
            uid: user.uid,
          );
        }
      case 1:
        {
          return WalletPageTabWithdrawal(
            balances: widget.balances[widget.selectedCardIndex],
            selectedBeneficiary: selectedBeneficiary,
            user: user,
            onWithdrawal: widget.onWithdrawal,
            onAddBeneficiary: widget.onAddBeneficiary,
            onWithdrawalHistory: widget.onWithdrawalHistory,
            currency: widget.balances[widget.selectedCardIndex].currency,
            beneficiaries: widget.beneficiaries,
          );
        }
      default:
        {
          return Container();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        centerTitle: true,
        title: Text(
          tr(
            'wallet',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? displayHeight(context) * 0.25
                        : displayWidth(context) * 0.25,
                child: Swiper(
                  onIndexChanged: (index) {
                    widget.onCardSelect(
                      index,
                      widget.balances[index].currency.id,
                    );
                  },
                  index: widget.selectedCardIndex,
                  itemCount: widget.balances.length,
                  viewportFraction: 0.8,
                  scale: 0.9,
                  itemBuilder: (BuildContext context, int index) {
                    var item = widget.balances[index];
                    return Container(
                      padding: const EdgeInsets.fromLTRB(
                        15,
                        20,
                        15,
                        15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [
                            Theme.of(context).colorScheme.primaryVariant,
                            Theme.of(context)
                                .colorScheme
                                .primaryVariant
                                .withOpacity(
                                  0.8,
                                ),
                            Theme.of(context)
                                .colorScheme
                                .primaryVariant
                                .withOpacity(
                                  0.5,
                                ),
                            Theme.of(context)
                                .colorScheme
                                .primaryVariant
                                .withOpacity(
                                  0.3,
                                ),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                maxRadius: 20.0,
                                backgroundColor: Colors.transparent,
                                child: item.currency.iconUrl != null
                                    ? item.currency.iconUrl.endsWith('svg')
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
                                              fontSize: 20.0,
                                            ),
                                      ),
                              ),
                              SpaceW10(),
                              Text(
                                item.currency.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                              )
                            ],
                          ),
                          Text(
                            item.currency.depositAddress ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                          Flex(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                  .withOpacity(
                                                    0.8,
                                                  ),
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
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        item.locked.toStringAsFixed(
                                                item.currency.precision) +
                                            " " +
                                            item.currency.id.toUpperCase(),
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .caption
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                                  .withOpacity(
                                                    0.8,
                                                  ),
                                            ),
                                      ),
                                      Text(
                                        item.balance.toStringAsFixed(
                                                item.currency.precision) +
                                            " " +
                                            item.currency.id.toUpperCase(),
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
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Column(
              children: <Widget>[
                TabBarComp(
                  tabNames: [tr('deposit'), tr('withdrawal')],
                  selectedTabIndex: widget.selectedTabIndex,
                  onTabSelect: widget.onTabSelect,
                ),
                Container(
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? displayHeight(context) * 0.49
                          : displayWidth(context) * 0.49,
                  padding: const EdgeInsets.all(
                    8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                    padding: const EdgeInsets.all(
                      10,
                    ),
                    child: walletPageTabSelector(
                        widget.selectedTabIndex,
                        widget.balances[widget.selectedCardIndex].currency ??
                            CurrencyItemState.initialState(),
                        widget.selectedBeneficiary,
                        widget.user),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
