import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInOrSignUp extends StatelessWidget {
  const SignInOrSignUp({
    this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: tr('log_in_label'),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Navigator.of(context).pushNamed('/signInPage'),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  decoration: TextDecoration.underline,
                ),
          ),
          TextSpan(
            text: ' ' + tr('or') + ' ',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          TextSpan(
            text: tr('sign_up_label'),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Navigator.of(context).pushNamed('/signUpPage'),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  decoration: TextDecoration.underline,
                ),
          ),
          TextSpan(
            text: ' ' + title,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
      ),
    );
  }
}
