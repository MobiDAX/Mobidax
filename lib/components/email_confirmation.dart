import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/account/account_model.dart';
import 'package:mobidax_redux/redux.dart';

import '../helpers/sizes_helpers.dart';
import '../web/components/form.dart';
import 'spacers.dart';

class EmailConfirmation extends StatelessWidget {
  const EmailConfirmation({
    this.onEmailConfirmation,
    this.onResendEmailConfirmation,
  });

  final Function(String) onEmailConfirmation;
  final Function(String) onResendEmailConfirmation;

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    var token = args != null ? args['token'] : null;
    var email = args != null ? args['email'] : null;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: isDesktop(context)
          ? null
          : AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).colorScheme.background,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              centerTitle: true,
              title: Text(
                tr('email_verification_label'),
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
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
              ? FormComponent(
                  heading: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            tr('email_verification_label'),
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                      ),
                      SpaceW24(),
                    ],
                  ),
                  content: Builder(
                    builder: (BuildContext context) {
                      return token != null
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).accentColor,
                                ),
                                semanticsLabel:
                                    "${tr('email_verification_label')}...",
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(
                                    32.0,
                                  ),
                                  child: Text(
                                    tr('email_verification_resend_text'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                    softWrap: true,
                                  ),
                                ),
                                SpaceH16(),
                                // ignore: deprecated_member_use
                                RaisedButton(
                                  child: Text(
                                    tr('email_verification_resend_button'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        ),
                                  ),
                                  onPressed: () {
                                    onResendEmailConfirmation(email);
                                  },
                                )
                              ],
                            );
                    },
                  ),
                )
              : token != null
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor,
                        ),
                        semanticsLabel: "${tr('email_verification_label')}...",
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(
                            32.0,
                          ),
                          child: Text(
                            tr('email_verification_resend_text'),
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                            softWrap: true,
                          ),
                        ),
                        SpaceH16(),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          child: Text(
                            tr('email_verification_resend_button'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                          ),
                          onPressed: () {
                            onResendEmailConfirmation(email);
                          },
                        )
                      ],
                    )
        ],
      ),
    );
  }
}

class EmailConfirmationConnector extends StatelessWidget {
  const EmailConfirmationConnector({
    this.confirmToken,
  });

  final String confirmToken;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      onInitialBuild: (vm) {
        final Map args = ModalRoute.of(context).settings.arguments;
        var token = args != null ? args['token'] : confirmToken;
        if (token != null) {
          vm.onEmailConfirmation(token);
        }
      },
      builder: (BuildContext context, AccountPageModel vm) => EmailConfirmation(
        onEmailConfirmation: vm.onEmailConfirmation,
        onResendEmailConfirmation: vm.onResendEmailConfirmation,
      ),
    );
  }
}
