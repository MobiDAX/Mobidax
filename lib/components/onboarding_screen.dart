import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helpers/sizes_helpers.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    this.buttons,
  });

  final Widget buttons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            height: displayHeight(context) * 1,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'assets/icons/waves.png',
                ),
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                        top: 60.0,
                      ),
                      width: 300,
                      height: 60,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                            'assets/icons/logo.png',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? displayHeight(context) * 0.1
                          : displayHeight(context) * 0.05,
                    ),
                    Text(
                      tr('description'),
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).primaryTextTheme.headline6.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? displayHeight(context) * 0.1
                          : displayHeight(context) * 0.05,
                    ),
                    buttons ??
                        Column(
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/signInPage');
                              },
                              child: Text(
                                tr('signInLabel'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/signUpPage');
                              },
                              child: Text(
                                tr('signUpLabel'),
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
                          ],
                        ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
