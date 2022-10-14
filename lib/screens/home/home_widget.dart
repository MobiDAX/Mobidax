import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../components/onboarding_screen.dart';
import '../../helpers/sizes_helpers.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    this.onGetStarted,
  });

  final Function() onGetStarted;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      buttons: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/signInPage',
              );
            },
            child: Text(
              tr('sign_in_label'),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/signUpPage');
            },
            child: Text(
              tr('sign_up_label'),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.1,
          ),
          TextButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
            ),
            onPressed: onGetStarted,
            child: Text(
              tr('skip_label'),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
