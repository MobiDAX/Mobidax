import 'package:async_redux/async_redux.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobidax_redux/persistor.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/web_persistor.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_strategy/url_strategy.dart';

import 'components/account_api_key.dart';
import 'components/account_screen_change_password.dart';
import 'components/account_screen_documents_verification.dart';
import 'components/account_screen_history.dart';
import 'components/account_screen_identity_verification.dart';
import 'components/account_screen_phone_verification.dart';
import 'components/authenteq_verification.dart';
import 'components/beneficiary_list.dart';
import 'components/email_confirmation.dart';
import 'components/error_screen.dart';
import 'components/order_placement_screen.dart';
import 'components/reset_password.dart';
import 'screens/account_activities/account_activities_connector.dart';
import 'screens/confirm_beneficiary/confirm_beneficiary_connector.dart';
import 'screens/create_beneficiary/create_beneficiary_widget.dart';
import 'screens/deposit_history/deposit_history_connector.dart';
import 'screens/enable_2fa/enable_2fa_widget.dart';
import 'screens/markets/markets_connector.dart';
import 'screens/nav/nav_wrapper.dart';
import 'screens/nav/web_nav_wrapper.dart';
import 'screens/sign_in/sign_in_widget.dart';
import 'screens/sign_up/sign_up_widget.dart';
import 'screens/wallet/wallet_connector.dart';
import 'screens/withdrawal/withdrawal_widget.dart';
import 'screens/withdrawal_history/withdrawal_history_connector.dart';
import 'utils/config.dart';
import 'utils/theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final persistor = UniversalPlatform.isWeb ? WebPersistor() : AppPersistor();

void main() async {
  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();

  final persistedState = await persistor.readState();
  final initialState = AppState.initialState();

  var appStore = Store<AppState>(
    persistor: persistor,
//    modelObserver: DefaultModelObserver(),
//    actionObservers: [Log<AppState>.printer()],
    initialState: initialState.copy(
      homePageState: persistedState.homePageState,
      marketsPageState: persistedState.marketsPageState,
      accountUserState: persistedState.accountUserState,
      //exchangePageState: persistedState.exchangePageState,
    ),
  );

  await appStore.dispatchFuture(MarketsFetchAction());
  appStore.dispatch(TickerSubAction());
  appStore.dispatch(FetchAuthenteqConfig());

  NavigateAction.setNavigatorKey(navigatorKey);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      setPathUrlStrategy();
      runApp(
        EasyLocalization(
          supportedLocales: supportedLocales,
          path: 'assets/lang', // <-- change patch to your
          fallbackLocale: const Locale(
            'en',
            'US',
          ),
          child: //DevicePreview(
              //builder: (context) => MyApp(),
              Mobidax(
            appStore: appStore,
          ),
          //),
        ),
      );
    },
  );
}

class Mobidax extends StatelessWidget {
  const Mobidax({
    this.appStore,
  });

  final Store appStore;

  @override
  Widget build(BuildContext context) {
    precacheImage(
      const AssetImage(
        'assets/icons/waves.png',
      ),
      context,
    );

    ErrorWidget.builder = errorScreen;

    return StoreProvider<AppState>(
      store: appStore,
      child: MaterialApp(
        title: 'MobiDAX Demo',
        theme: appTheme(),
        locale: EasyLocalization.of(context).locale,
        localizationsDelegates: const [
          CountryLocalizations.delegate,
        ],
        navigatorKey: navigatorKey,
        routes: {
          '/': (context) => MediaQuery.of(context).size.width > 700.0
              ? NavWebScreenConnector()
              : NavScreenConnector(),
          '/selectMarket': (context) => Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  title: Text(
                    tr('markets_tab'),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                body: MarketPageConnector(
                  false,
                  (item) {},
                ),
              ),
          '/orderPlacementPage': (context) =>
              Scaffold(body: OrderPlacementScreen()),
          '/signInPage': (context) => SignIn(),
          '/signUpPage': (context) => SignUp(),
          '/accountOrderHistory': (context) =>
              AccountScreenOrderHistoryConnector(),
          '/accountTradeHistory': (context) =>
              AccountScreenTradeHistoryConnector(),
          '/accountChangePassword': (context) =>
              AccountScreenChangePasswordWrapper(),
          '/apiKey': (context) => ApiKeyConnector(),
          '/accountActivities': (context) => AccountActivitiesPageConnector(),
          '/accountAddPhone': (context) => AccountScreenAddPhoneWrapper(),
          '/accountVerifyPhone': (context) => AccountScreenVerifyPhoneWrapper(),
          '/accountVerifyIdentity': (context) =>
              AccountScreenVerifyIdentityWrapper(),
          '/accountVerifyDocuments': (context) =>
              AccountScreenVerifyDocumentsWrapper(),
          '/accountEnable2FA': (context) => Enable2FA(),
          '/wallet': (context) => WalletPageConnector(),
          '/beneficiaryList': (context) => BeneficiaryListWrapper(),
          '/createBeneficiary': (context) => CreateBeneficiaryWrapper(),
          '/confirmBeneficiary': (context) => ConfirmBeneficiaryPageConnector(),
          '/withdrawal': (context) => WithdrawalWrapper(),
          '/withdrawalHistory': (context) => WithdrawalHistoryPageConnector(),
          '/depositHistory': (context) => DepositHistoryPageConnector(),
          '/emailConfirmation': (context) => EmailConfirmationConnector(),
          '/authenteqVerification': (context) =>
              AuthenteqVerificationConnector(),
          '/resetPassword': (context) => ResetPasswordWrapper(),
          '': (context) => ResetPasswordWrapper(),
        },
        onGenerateRoute: (settings) {
          final List<String> pathComponents = settings.name.split('/');

          final refid = pathComponents.firstWhere(
              (element) => element.contains('signup?refid='), orElse: () {
            return null;
          });

          if (refid != null &&
              refid.split('signup?refid=')[1] != null &&
              refid.split('signup?refid=')[1].split('#')[0] != null) {
            return MaterialPageRoute(
              builder: (context) => SignUp(
                refId: refid.split('signup?refid=')[1].split('#')[0],
              ),
            );
          }

          final authenteqCode = pathComponents
              .firstWhere((element) => element.contains('?code='), orElse: () {
            return null;
          });

          if (authenteqCode != null &&
              authenteqCode.split('?code=')[1] != null) {
            appStore.dispatch(
              AuthenteqVericationAction(code: authenteqCode.split('?code=')[1]),
            );

            appStore.dispatch(
              UpdateUserProfile(),
            );

            return MaterialPageRoute(
              builder: (context) => Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
            );
          }

          switch (settings.name.split('?')[0]) {
            case '/accounts/confirmation':
              final confirmToken = pathComponents
                  .firstWhere(
                      (element) => element.contains('confirmation_token'))
                  .split('=')[1]
                  .split('&')[0];
              return MaterialPageRoute(
                builder: (context) => EmailConfirmationConnector(
                  confirmToken: confirmToken,
                ),
              );
              break;
            case '/accounts/password_reset':
              final resetToken = pathComponents
                  .firstWhere(
                    (element) => element.contains('reset_token'),
                  )
                  .split('=')[1]
                  .split('&')[0];
              return MaterialPageRoute(
                builder: (context) => ResetPasswordWrapper(
                  resetToken: resetToken,
                ),
              );
              break;
            default:
              return MaterialPageRoute(
                builder: (context) => MediaQuery.of(context).size.width > 700.0
                    ? NavWebScreenConnector()
                    : NavScreenConnector(),
              );
          }
        },
      ),
    );
  }
}
