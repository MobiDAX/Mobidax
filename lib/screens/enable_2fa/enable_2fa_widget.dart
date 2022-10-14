import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/account/account_state.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../components/account_screen_inputs.dart';
import '../../components/otp_code.dart';
import '../../helpers/sizes_helpers.dart';
import '../../web/components/form.dart';
import '../../web/components/modal_header.dart';
import 'enable_2fa_connector.dart';

// ignore: must_be_immutable
class Enable2FA extends StatelessWidget {
  Enable2FA({
    this.enabled2FA,
  });

  bool enabled2FA;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) enabled2FA = arguments['enabled2FA'];

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
              title: enabled2FA
                  ? Text(tr('disable_2fa'))
                  : Text(
                      tr('enable_2fa'),
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
          Enable2FAConnector(),
        ],
      ),
    );
  }
}

class Enable2FAPage extends StatelessWidget {
  const Enable2FAPage({
    this.onVerifyOTP,
    this.secret,
    this.enabled2FA,
    @required this.userName,
  });

  final bool enabled2FA;
  final Function(String) onVerifyOTP;
  final String secret;
  final String userName;

  Widget buildWeb(BuildContext context) {
    print('USER NAME IS: $userName');
    return FormComponent(
      heading: ModalHeader(
        title: enabled2FA ? tr('disable_2fa') : tr('enable_2fa'),
      ),
      content: enabled2FA
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tr('enter_2fa'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  OtpField(
                    bgColor: Theme.of(context).colorScheme.primary,
                    onVerifyOTP: (String value) {
                      onVerifyOTP(value);
                    },
                  ),
                ],
              ),
            )
          : secret == ''
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor,
                    ),
                  ),
                )
              : Container(
                  color: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            child: QrImage(
                              data:
                                  'otpauth://totp/$userName?secret=$secret&issuer=${tr('app_title')}',
                              version: QrVersions.auto,
                              gapless: true,
                              size: 125,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: Text(
                            tr('2fa_google_auh'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: CopyField(
                            text: secret,
                          ),
                        ),
                        Container(
                          child: Text(
                            tr('2fa_code'),
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        OtpField(
                          bgColor: Theme.of(context).colorScheme.primary,
                          onVerifyOTP: (String value) {
                            onVerifyOTP(value);
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
    return isDesktop(context)
        ? buildWeb(context)
        : enabled2FA
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tr('enter_2fa'),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    OtpField(
                      onVerifyOTP: (String value) {
                        onVerifyOTP(value);
                      },
                    ),
                  ],
                ),
              )
            : secret == ''
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor,
                      ),
                    ),
                  )
                : Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: Theme.of(context).colorScheme.background,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: Text(
                                    tr('2fa_google_auh'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: CopyField(
                                    text: secret,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    tr('2fa_code'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                OtpField(
                                  onVerifyOTP: (String value) {
                                    onVerifyOTP(value);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
  }
}
