import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax/components/spacers.dart';
import 'package:mobidax_redux/account/account_model.dart';
import 'package:mobidax_redux/redux.dart';

import '../helpers/sizes_helpers.dart';
import '../web/components/form.dart';

class AuthenteqVerification extends StatelessWidget {
  const AuthenteqVerification({
    this.authenteqUrl,
    this.getAuthenteqUrl,
  });

  final VoidCallback getAuthenteqUrl;
  final String authenteqUrl;

  @override
  Widget build(BuildContext context) {
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
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: true,
              title: Text(
                tr('identity_verification_label'),
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
                          Navigator.of(context).pop();
                        },
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            tr('identity_verification_label'),
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
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(
                              32.0,
                            ),
                            child: Text(
                              tr(
                                'authenteq_verification_text',
                              ),
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
                          ElevatedButton(
                            child: Text(
                              tr(
                                'verify_label',
                              ),
                            ),
                            onPressed: () {
                              getAuthenteqUrl();
                            },
                          )
                        ],
                      );
                    },
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
                        tr(
                          'authenteq_verification_text',
                        ),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                        softWrap: true,
                      ),
                    ),
                    SpaceH16(),
                    ElevatedButton(
                      child: Text(
                        tr(
                          'verify_label',
                        ),
                      ),
                      onPressed: () {
                        getAuthenteqUrl();
                      },
                    )
                  ],
                ),
        ],
      ),
    );
  }
}

class AuthenteqVerificationConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      builder: (BuildContext context, AccountPageModel vm) =>
          AuthenteqVerification(
        getAuthenteqUrl: vm.getAuthenteqUrl,
      ),
    );
  }
}
