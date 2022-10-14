import 'package:async_redux/async_redux.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobidax_redux/account/account_model.dart';
import 'package:mobidax_redux/store.dart';
import 'package:mobidax_redux/types.dart';

import '../helpers/error_notifier.dart';
import '../helpers/sizes_helpers.dart';
import '../web/components/form.dart';
import '../web/components/modal_header.dart';
import 'otp_code.dart';
import 'spacers.dart';

class AccountScreenVerifyPhoneWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isDesktop(context)
          ? null
          : AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).colorScheme.primary,
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
                tr('phone_verification_label'),
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
      backgroundColor: Theme.of(context).colorScheme.background,
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
          AccountScreenVerifyPhoneConnector(),
        ],
      ),
    );
  }
}

class AccountScreenVerifyPhoneConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      onWillChange: (vm) {
        if (vm.error != null) {
          vm.clearError();
          SnackBarNotifier.createSnackBar(
            tr(vm.error.graphqlErrors.first.message) ??
                tr('something_went_wrong'),
            context,
            Status.error,
          );
        }
      },
      builder: (BuildContext context, AccountPageModel vm) =>
          AccountScreenVerifyPhone(
        onVerifyPhone: vm.onVerifyPhone,
      ),
    );
  }
}

class AccountScreenVerifyPhone extends StatelessWidget {
  const AccountScreenVerifyPhone({
    this.onVerifyPhone,
  });

  final Function(String phone, String code) onVerifyPhone;

  Widget buildWeb(BuildContext context, _number) {
    return FormComponent(
      heading: ModalHeader(
        title: tr('phone_verification_label'),
      ),
      content: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Text(
                  tr('phone_verification_instruction'),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ),
              OtpField(
                bgColor: Theme.of(context).colorScheme.primary,
                length: 5,
                onVerifyOTP: (String value) {
                  onVerifyPhone(
                    _number,
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
    final String _number = ModalRoute.of(context).settings.arguments;

    return isDesktop(context)
        ? buildWeb(context, _number)
        : Center(
            child: Container(
              color: Theme.of(context).colorScheme.background,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Text(
                      tr('phone_verification_instruction'),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                  OtpField(
                    length: 5,
                    onVerifyOTP: (String value) {
                      onVerifyPhone(
                        _number,
                        value,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}

class AccountScreenAddPhone extends StatefulWidget {
  const AccountScreenAddPhone({
    this.onAddPhone,
  });

  final Function onAddPhone;

  @override
  _AccountScreenAddPhoneState createState() => _AccountScreenAddPhoneState();
}

class _AccountScreenAddPhoneState extends State<AccountScreenAddPhone> {
  final _formKey = GlobalKey<FormState>();
  String _number = "";
  CountryCode _countryCode;
  bool _loading = false;

  Widget buildWeb(BuildContext context, locale) {
    return FormComponent(
      heading: ModalHeader(
        title: tr(
          'phone_confirm_label',
        ),
      ),
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                tr('phone_add_text'),
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                softWrap: true,
              ),
              SpaceH16(),
              CountryCodePicker(
                dialogSize: Size(440.0, displayHeight(context) * 0.5),
                searchStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                dialogTextStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                onChanged: (code) {
                  setState(
                    () {
                      _countryCode = code;
                    },
                  );
                },
                builder: (code) {
                  return Container(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primaryVariant,
                      ),
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _countryCode != null
                              ? _countryCode.dialCode
                              : CountryCode.fromCode(locale.countryCode)
                                  .dialCode,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        Text(
                          " (${_countryCode != null ? _countryCode.name : CountryCode.fromCode(locale.countryCode).name})",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        SpaceW32(),
                        const Icon(
                          Icons.arrow_drop_down,
                        )
                      ],
                    ),
                  );
                },
                emptySearchBuilder: (BuildContext context) {
                  return Center(
                    child: Text(
                      tr('no_items'),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  );
                },
                textStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: locale.countryCode,
                // optional. Shows only country name and flag
                showFlag: true,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: true,
                // optional. aligns the flag and the Text left
                alignLeft: false,
              ),
              SpaceH16(),
              TextFormField(
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                initialValue: _number,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onFieldSubmitted: (number) {
                  setState(
                    () {
                      _number = number;
                    },
                  );
                },
                onSaved: (number) {
                  setState(
                    () {
                      _number = number;
                    },
                  );
                },
                validator: (number) {
                  if (number.length < 4)
                    return tr('resource.phone.invalid_num');
                  else
                    return null;
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: Text(
                      _countryCode != null
                          ? _countryCode.dialCode
                          : CountryCode.fromCode(locale.countryCode).dialCode,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 19,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                ),
              ),
              SpaceH16(),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() {
                              _loading = true;
                            });
                            widget.onAddPhone(
                              _countryCode.dialCode + _number,
                              () => setState(
                                () {
                                  _loading = false;
                                },
                              ),
                            );
                          }
                        },
                        child: Text(
                          tr('phone_verification_button'),
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
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
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return _loading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.primary,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).accentColor,
              ),
            ),
          )
        : isDesktop(context)
            ? buildWeb(context, myLocale)
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(
                    52.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          tr('phone_add_text'),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                          softWrap: true,
                        ),
                        SpaceH16(),
                        CountryCodePicker(
                          searchStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                          dialogTextStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                          onChanged: (code) {
                            setState(
                              () {
                                _countryCode = code;
                              },
                            );
                          },
                          builder: (code) {
                            return Container(
                              padding: const EdgeInsets.all(
                                8.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant),
                                borderRadius: BorderRadius.circular(
                                  8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    _countryCode != null
                                        ? _countryCode.dialCode
                                        : CountryCode.fromCode(
                                            myLocale.countryCode,
                                          ).dialCode,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                  ),
                                  Text(
                                    " (${_countryCode != null ? _countryCode.name : CountryCode.fromCode(myLocale.countryCode).name})",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                  ),
                                  SpaceW32(),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                  )
                                ],
                              ),
                            );
                          },
                          emptySearchBuilder: (BuildContext context) {
                            return Center(
                              child: Text(
                                tr('no_items'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                            );
                          },
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: myLocale.countryCode,
                          // optional. Shows only country name and flag
                          showFlag: true,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: true,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                        SpaceH16(),
                        TextFormField(
                          cursorColor:
                              Theme.of(context).textSelectionTheme.cursorColor,
                          initialValue: _number,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onFieldSubmitted: (number) {
                            setState(
                              () {
                                _number = number;
                              },
                            );
                          },
                          onSaved: (number) {
                            setState(
                              () {
                                _number = number;
                              },
                            );
                          },
                          validator: (number) {
                            if (number.length < 4)
                              return tr('resource.phone.invalid_num');
                            else
                              return null;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            prefixStyle: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                              ),
                              child: Text(
                                _countryCode != null
                                    ? _countryCode.dialCode
                                    : CountryCode.fromCode(myLocale.countryCode)
                                        .dialCode,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        SpaceH16(),
                        Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      setState(
                                        () {
                                          _loading = true;
                                        },
                                      );
                                      widget.onAddPhone(
                                        _countryCode.dialCode + _number,
                                        () => setState(
                                          () {
                                            _loading = false;
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    tr('phone_verification_button'),
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        ),
                                  ),
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
  }
}

class AccountScreenAddPhoneConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      onWillChange: (vm) {
        if (vm.error != null) {
          vm.clearError();
          SnackBarNotifier.createSnackBar(
            tr(vm.error.graphqlErrors.first.message) ?? 'Something went wrong',
            context,
            Status.error,
          );
        }
      },
      builder: (BuildContext context, AccountPageModel vm) =>
          AccountScreenAddPhone(
        onAddPhone: vm.onAddPhone,
      ),
    );
  }
}

class AccountScreenAddPhoneWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isDesktop(context)
          ? null
          : AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).colorScheme.primary,
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
                tr('phone_verification_label'),
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
      backgroundColor: Theme.of(context).colorScheme.background,
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
          AccountScreenAddPhoneConnector(),
        ],
      ),
    );
  }
}
