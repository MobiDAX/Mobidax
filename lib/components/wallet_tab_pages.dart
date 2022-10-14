import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mobidax/components/spacers.dart';
import 'package:mobidax_redux/account/account_state.dart';
import 'package:mobidax_redux/types.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../helpers/error_notifier.dart';
import '../helpers/sizes_helpers.dart';
import '../utils/text_input_formatter.dart';
import 'account_screen_inputs.dart';

class WalletPageTabDeposit extends StatelessWidget {
  const WalletPageTabDeposit({
    @required this.onDepositHistory,
    @required this.selectedCurrency,
    @required this.uid,
  });

  final Function() onDepositHistory;
  final CurrencyItemState selectedCurrency;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ClipRRect(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.history,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        onPressed: onDepositHistory,
                      ),
                    ),
                  ],
                ),
                selectedCurrency.type == 'fiat'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tr('bank_name_label'),
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: CopyField(
                              text: tr(
                                'bank_name',
                              ),
                            ),
                          ),
                          Text(
                            tr(
                              'bank_account_label',
                            ),
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: CopyField(
                              text: tr(
                                'bank_account',
                              ),
                            ),
                          ),
                          Text(
                            tr(
                              'bank_account_number_label',
                            ),
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: CopyField(
                              text: tr(
                                'bank_account_number',
                              ),
                            ),
                          ),
                          Text(
                            tr(
                              'reference_number_label',
                            ),
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: CopyField(
                              text: uid,
                            ),
                          ),
                        ],
                      )
                    : selectedCurrency.depositAddress == "" ||
                            selectedCurrency.depositAddress == null
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).accentColor,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ),
                                    ),
                                    child: QrImage(
                                      data:
                                          selectedCurrency.depositAddress ?? "",
                                      gapless: true,
                                      size: 125,
                                    ),
                                  ),
                                ),
                                SpaceH10(),
                                Text(
                                  tr('deposit_wallet_address'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                                SpaceH5(),
                                CopyField(
                                  text: selectedCurrency.depositAddress ?? "",
                                ),
                              ],
                            ),
                          )
              ],
            ),
            selectedCurrency.depositEnabled
                ? SizedBox()
                : BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10.0,
                      sigmaY: 10.0,
                    ),
                    child: Container(
                      height: isDesktop(context)
                          ? 300
                          : displayHeight(context) * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.0),
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock,
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
                              size: 48.0,
                            ),
                            SpaceH16(),
                            Text(
                              tr('deposit_disabled'),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
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

class WalletPageTabWithdrawal extends StatefulWidget {
  const WalletPageTabWithdrawal(
      {this.onWithdrawal,
      this.user,
      this.onAddBeneficiary,
      this.onWithdrawalHistory,
      this.beneficiaries,
      this.selectedBeneficiary,
      this.currency,
      this.balances});

  final Function onWithdrawal;
  final UserState user;
  final Function onAddBeneficiary;
  final Function() onWithdrawalHistory;
  final CurrencyItemState currency;
  final List<Beneficiary> beneficiaries;
  final Beneficiary selectedBeneficiary;
  final UserBalanceItemState balances;

  @override
  _WalletPageTabWithdrawalState createState() =>
      _WalletPageTabWithdrawalState();
}

class _WalletPageTabWithdrawalState extends State<WalletPageTabWithdrawal> {
  final amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  widget.onWithdrawalHistory != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: widget.onWithdrawalHistory,
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.history,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  Text(
                    tr('withdraw_wallet_label'),
                    style: Theme.of(context).textTheme.caption.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  SpaceH8(),
                  AccountButton(
                    text: widget.selectedBeneficiary != null
                        ? widget.selectedBeneficiary.name
                        : widget.beneficiaries.isEmpty
                            ? tr('add_benef_button_label')
                            : tr('choose_benef_button_label'),
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/beneficiaryList');
                    },
                    buttonColor: Theme.of(context).colorScheme.primaryVariant,
                  ),
                  SpaceH8(),
                  TextFormField(
                    cursorColor:
                        Theme.of(context).textSelectionTheme.cursorColor,
                    controller: amountController,
                    validator: (value) {
                      if (double.parse(
                              (value == '' ? '0' : amountController.text)) <
                          widget.currency.min_withdraw_amount) {
                        return '${tr('withdrawal_amount_lower')} ${widget.currency.min_withdraw_amount}  ${widget.currency.id.toUpperCase()}';
                      } else if (double.parse(
                                  (value == '' ? '0' : amountController.text)) -
                              widget.currency.withdrawFee >
                          widget.balances.balance -
                              widget.currency.withdrawFee) {
                        return tr('withdrawal_amount_higher');
                      } else {
                        return null;
                      }
                    },
                    onChanged: (str) {
                      _formKey.currentState.validate();
                      setState(() {});
                    },
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      NumberTextInputFormatter(
                        decimalRange: widget.currency.precision,
                      ),
                      RegExInputFormatter.withRegex(
                          '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$')
                    ],
                    decoration: InputDecoration(
                        hintText:
                            '${tr('Minimal')} ${widget.currency.min_withdraw_amount}'),
                  ),
                  SpaceH8(),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              tr('withdraw_fee_label'),
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
                            SpaceH16(),
                            Text(
                              tr('net_withdraw_amount_label'),
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
                          ],
                        ),
                      ),
                      SpaceH8(),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              (widget.currency.withdrawFee ?? 0.0)
                                      .toStringAsFixed(
                                          widget.currency.precision) +
                                  " " +
                                  widget.currency.id.toUpperCase(),
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
                            SpaceH16(),
                            Text(
                              (double.tryParse(amountController.text
                                                  .replaceAll(',', '.')) ==
                                              null
                                          ? 0.0
                                          : (double.tryParse(amountController
                                                      .text
                                                      .replaceAll(',', '.')) >
                                                  widget.currency.withdrawFee)
                                              ? double.tryParse(amountController
                                                      .text
                                                      .replaceAll(',', '.')) -
                                                  widget.currency.withdrawFee
                                              : 0.00)
                                      .toStringAsFixed(
                                          widget.currency.precision) +
                                  " " +
                                  widget.currency.id.toUpperCase(),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  SpaceH8(),
                  AccountButton(
                    text: tr('withdraw_button_label'),
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    onPressed: (double.parse((amountController.text == ''
                                        ? '0'
                                        : amountController.text)) -
                                    widget.currency.withdrawFee <=
                                widget.balances.balance -
                                    widget.currency.withdrawFee) &&
                            amountController.text.isNotEmpty &&
                            double.parse((amountController.text == ''
                                    ? '0'
                                    : amountController.text)) >=
                                widget.currency.min_withdraw_amount
                        ? () {
                            if (!widget.user.otp) {
                              SnackBarNotifier.createSnackBar(
                                tr("2fa_to_withdraw"),
                                context,
                                Status.error,
                              );
                            }
                            if (widget.selectedBeneficiary == null) {
                              SnackBarNotifier.createSnackBar(
                                tr('benef_first'),
                                context,
                                Status.error,
                              );
                            }

                            if (widget.selectedBeneficiary != null &&
                                double.tryParse(amountController.text
                                        .replaceAll(',', '.')) !=
                                    null &&
                                widget.user.otp)
                              Navigator.of(context).pushNamed(
                                '/withdrawal',
                                arguments: double.parse(
                                  amountController.text.replaceAll(',', '.'),
                                ),
                              );
                            amountController.clear();
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
          handleWithdrawal(
            currency: widget.currency,
            user: widget.user,
          ),
        ],
      ),
    );
  }

  Widget handleWithdrawal({CurrencyItemState currency, UserState user}) {
    baseWidget({List<Widget> child}) {
      return Container(
        color: Theme.of(context).colorScheme.primary,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                      SpaceH80(),
                      Icon(
                        Icons.lock,
                        color: Theme.of(context).colorScheme.primaryVariant,
                        size: 48.0,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ] +
                    child,
              ),
            ),
          ),
        ),
      );
    }

    if (!currency.withdrawalEnabled) {
      return baseWidget(
        child: [
          Text(
            tr('withdrawal_disabled'),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Theme.of(context).colorScheme.primaryVariant),
          ),
          SpaceH92(),
        ],
      );
    } else if (user.level == 2 &&
        (user.labels.contains(UserLabel(
                key: 'document', value: 'pending', scope: 'private')) ||
            user.labels.firstWhere((element) => element.key == 'document',
                    orElse: () {
                  return null;
                }) !=
                null)) {
      return baseWidget(
        child: [
          Text(
            tr('withdrawal_kyc_wait'),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Theme.of(context).colorScheme.primaryVariant),
          ),
          SpaceH32(),
        ],
      );
    } else if (user.level < 3) {
      return baseWidget(
        child: [
          Text(
            tr('withdrawal_no_kyc'),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context).colorScheme.primaryVariant,
                ),
          ),
          SpaceH32(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AccountButton(
              buttonColor: Theme.of(context).colorScheme.primaryVariant,
              textColor: Theme.of(context).colorScheme.primary,
              text: tr('Verify'),
              onPressed: () {
                if (user.level == 1) {
                  Navigator.of(context).pushNamed('/accountAddPhone');
                } else {
                  Navigator.of(context).pushNamed('/accountVerifyIdentity');
                }
              },
            ),
          ),
        ],
      );
    } else if (!user.otp) {
      return baseWidget(
        child: [
          Text(
            tr('withdrawal_no_2fa'),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context).colorScheme.primaryVariant,
                ),
          ),
          SpaceH32(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AccountButton(
              buttonColor: Theme.of(context).colorScheme.primaryVariant,
              textColor: Theme.of(context).colorScheme.primary,
              text: tr('enable_2fa'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/accountEnable2FA',
                  arguments: {
                    'enabled2FA': widget.user.otp,
                  },
                );
              },
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
