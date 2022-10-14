import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/account/account_state.dart';

import '../../components/otp_code.dart';
import '../../helpers/sizes_helpers.dart';
import '../../web/components/form.dart';
import '../../web/components/modal_header.dart';

class ConfirmBeneficiaryPage extends StatelessWidget {
  const ConfirmBeneficiaryPage({
    this.onConfirmBeneficiary,
    this.createdBeneficiary,
  });

  final Function(int id, String pin) onConfirmBeneficiary;
  final Beneficiary createdBeneficiary;

  Widget buildWeb(BuildContext context) {
    return FormComponent(
      bgColor: Theme.of(context).colorScheme.primary,
      heading: ModalHeader(
        title: tr(
          'beneficiary_page_title',
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                tr('confirm_benef'),
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: Icon(
                        Icons.mail_outline,
                        size: 40,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tr('benef_code'),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              OtpField(
                bgColor: Theme.of(context).colorScheme.primary,
                onVerifyOTP: (String value) {
                  onConfirmBeneficiary(
                    createdBeneficiary.id,
                    value,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              title: Text(
                tr(
                  'beneficiary_page_title',
                ),
              ),
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
          isDesktop(context)
              ? buildWeb(context)
              : Container(
                  color: Theme.of(context).colorScheme.background,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        tr('confirm_benef'),
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(
                                right: 20,
                              ),
                              child: Icon(
                                Icons.mail_outline,
                                size: 40,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tr('benef_code'),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      OtpField(
                        onVerifyOTP: (String value) {
                          onConfirmBeneficiary(
                            createdBeneficiary.id,
                            value,
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
