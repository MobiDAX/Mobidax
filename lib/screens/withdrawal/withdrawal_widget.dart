import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/account/account_state.dart';

import '../../components/otp_code.dart';
import '../../components/spacers.dart';
import '../../helpers/sizes_helpers.dart';
import '../../web/components/form.dart';
import '../../web/components/modal_header.dart';
import 'withdrawal_connector.dart';

class WithdrawalWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: isDesktop(context)
          ? null
          : AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: true,
              title: Text(tr('withdrawal')),
            ),
      body: Stack(
        children: [
          isDesktop(context)
              ? Image(
                  image: const AssetImage(
                    'assets/icons/waves.png',
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                )
              : Container(),
          WithdrawalPageConnector(),
        ],
      ),
    );
  }
}

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({
    this.onWithdraw,
    this.selectedBeneficiary,
  });

  final Function onWithdraw;
  final Beneficiary selectedBeneficiary;

  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  String _pincode;

  Widget buildWeb(BuildContext context, amount) {
    return FormComponent(
      bgColor: Theme.of(context).colorScheme.background,
      heading: ModalHeader(
        title: tr('withdrawal'),
      ),
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpaceH60(),
              Text(
                tr('enter_2fa_to_withdraw'),
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(
                            0.8,
                          ),
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "$amount ${widget.selectedBeneficiary.currency.toUpperCase()} ${tr('to_account')} ${widget.selectedBeneficiary.address}",
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(
                                    0.8,
                                  ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              OtpField(
                onVerifyOTP: (String value) {
                  setState(
                    () {
                      _pincode = value;
                    },
                  );
                },
              ),
              SpaceH36(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    child: MaterialButton(
                      color: Colors.lightGreen,
                      onPressed: () {
                        widget.onWithdraw(
                          widget.selectedBeneficiary.currency,
                          widget.selectedBeneficiary.id,
                          amount,
                          _pincode,
                        );
                      },
                      child: Text(
                        tr('confirm'),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  SpaceH32(),
                  Flexible(
                    child: MaterialButton(
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        tr('cancel'),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var amount = ModalRoute.of(context).settings.arguments;
    return isDesktop(context)
        ? buildWeb(context, amount)
        : SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpaceH60(),
                  Text(
                    tr('enter_2fa_to_withdraw'),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.8),
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "$amount ${widget.selectedBeneficiary.currency.toUpperCase()} ${tr('to_account')} ${widget.selectedBeneficiary.address}",
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(
                                            0.8,
                                          ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  OtpField(
                    onVerifyOTP: (String value) {
                      setState(
                        () {
                          _pincode = value;
                        },
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 40,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MaterialButton(
                          minWidth: displayWidth(context) * 0.2,
                          color: Colors.lightGreen,
                          onPressed: () {
                            widget.onWithdraw(
                              widget.selectedBeneficiary.currency,
                              widget.selectedBeneficiary.id,
                              amount,
                              _pincode,
                            );
                          },
                          child: Text(
                            tr('confirm'),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        MaterialButton(
                          minWidth: displayWidth(context) * 0.2,
                          color: Colors.red,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            tr('cancel'),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
