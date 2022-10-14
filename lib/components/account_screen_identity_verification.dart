import 'package:async_redux/async_redux.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'spacers.dart';
import 'package:mobidax_redux/account/account_model.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/store.dart';
import 'package:mobidax_redux/types.dart';

import '../helpers/error_notifier.dart';
import '../helpers/sizes_helpers.dart';
import '../utils/theme.dart';
import '../web/components/form.dart';
import '../web/components/modal_header.dart';

class AccountScreenVerifyIdentityConnector extends StatelessWidget {
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
          AccountScreenVerifyIdentity(
        profile: vm.user.profile,
        onUpdateProfile: vm.onUpdateProfile,
        authenteqEnabled: vm.authenteqEnabled,
      ),
    );
  }
}

class AccountScreenVerifyIdentityWrapper extends StatelessWidget {
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
                tr('identity_verification_label'),
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
          AccountScreenVerifyIdentityConnector(),
        ],
      ),
    );
  }
}

class AccountScreenVerifyIdentity extends StatefulWidget {
  const AccountScreenVerifyIdentity({
    this.profile,
    this.onUpdateProfile,
    this.authenteqEnabled,
  });

  final Function(String, String, String, String, String, String, String)
      onUpdateProfile;
  final UserProfile profile;
  final bool authenteqEnabled;

  @override
  _AccountScreenVerifyIdentityState createState() =>
      _AccountScreenVerifyIdentityState();
}

class _AccountScreenVerifyIdentityState
    extends State<AccountScreenVerifyIdentity> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateCtl = TextEditingController();
  String _firstName,
      _lastName,
      _city,
      _address,
      _postcode,
      _countryOfResidence = '';
  bool controlletCountry = true;

  Widget buildWeb(BuildContext context) {
    return FormComponent(
      heading: ModalHeader(
        title: tr(
          'identity_verification_label',
        ),
      ),
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                initialValue: widget.profile != null
                    ? widget.profile.firstName ?? ''
                    : null,
                keyboardType: TextInputType.text,
                onSaved: (str) => _firstName = str,
                onFieldSubmitted: (str) {
                  setState(
                    () {
                      _firstName = str;
                    },
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return tr('please_fill_field');
                  } else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: tr('identity_first_name'),
                ),
              ),
              SpaceH16(),
              TextFormField(
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                initialValue: widget.profile != null
                    ? widget.profile.lastName ?? ''
                    : null,
                keyboardType: TextInputType.text,
                onSaved: (str) => _lastName = str,
                onFieldSubmitted: (str) {
                  setState(
                    () {
                      _lastName = str;
                    },
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return tr('please_fill_field');
                  } else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: tr('identity_last_name'),
                ),
              ),
              SpaceH16(),
              TextFormField(
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                readOnly: true,
                controller: _dateCtl,
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  DateTime date;
                  FocusScope.of(context).requestFocus(
                    FocusNode(),
                  );

                  date = await showDatePicker(
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: appTheme().copyWith(
                          colorScheme: appTheme().colorScheme.copyWith(
                                onSurface: onPrimary,
                                primary: primaryVariant,
                                onPrimary: Colors.white,
                              ),
                        ),
                        child: child,
                      );
                    },
                    context: context,
                    initialEntryMode: DatePickerEntryMode.calendar,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(
                      1920,
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _dateCtl.text = date.toString().split(' ')[0];
                  }
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return tr('please_fill_field');
                  } else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: tr('identity_date_of_birth'),
                ),
              ),
              SpaceH16(),
              CountryCodePicker(
                dialogSize: Size(440.0, displayHeight(context) * 0.5),
                initialSelection: widget.profile != null
                    ? widget.profile.country ?? null
                    : null,
                searchStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                dialogTextStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                onChanged: (code) {
                  setState(
                    () {
                      _countryOfResidence = code.code;
                    },
                  );
                },
                builder: (code) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(
                          8.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: (controlletCountry)
                                ? Theme.of(context).colorScheme.primaryVariant
                                : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  _countryOfResidence != ''
                                      ? CountryCode.fromCode(
                                              _countryOfResidence)
                                          .name
                                      : (widget.profile != null &&
                                              widget.profile.country != null &&
                                              widget.profile.country != '')
                                          ? CountryCode.fromCode(
                                                widget.profile.country,
                                              ).name ??
                                              tr('identity_residence')
                                          : tr('identity_residence'),
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
                          ],
                        ),
                      ),
                      (controlletCountry)
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(left: 9, top: 4),
                              child: Text(tr('please_fill_field'),
                                  style: TextStyle(
                                    color: Colors.red,
                                  )),
                            )
                    ],
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
                showFlag: true,
                showCountryOnly: true,
                showOnlyCountryWhenClosed: true,
                alignLeft: false,
              ),
              SpaceH16(),
              TextFormField(
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                initialValue:
                    widget.profile != null ? widget.profile.city ?? null : null,
                keyboardType: TextInputType.text,
                onSaved: (str) => _city = str,
                onFieldSubmitted: (str) {
                  setState(
                    () {
                      _city = str;
                    },
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return tr('please_fill_field');
                  } else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: tr('identity_city'),
                ),
              ),
              SpaceH16(),
              TextFormField(
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                initialValue: widget.profile != null
                    ? widget.profile.address ?? null
                    : null,
                keyboardType: TextInputType.text,
                onSaved: (str) => _address = str,
                onFieldSubmitted: (str) {
                  setState(
                    () {
                      _address = str;
                    },
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return tr('please_fill_field');
                  } else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: tr('identity_residential_address'),
                ),
              ),
              SpaceH16(),
              TextFormField(
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                initialValue: widget.profile != null
                    ? widget.profile.postcode ?? null
                    : null,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                onSaved: (str) => _postcode = str,
                onFieldSubmitted: (str) {
                  setState(
                    () {
                      _postcode = str;
                    },
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return tr('please_fill_field');
                  } else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: tr('identity_postcode'),
                ),
              ),
              SpaceH16(),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      child: Text(
                        tr('verify_label'),
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate() &&
                            _countryOfResidence.isNotEmpty) {
                          _formKey.currentState.save();
                          widget.onUpdateProfile(
                            _firstName,
                            _lastName,
                            _dateCtl.text,
                            _countryOfResidence,
                            _city,
                            _address,
                            _postcode,
                          );
                        } else {
                          if (_countryOfResidence.isNotEmpty) {
                            setState(() {
                              controlletCountry = true;
                            });
                          } else if (_countryOfResidence.isEmpty) {
                            setState(() {
                              controlletCountry = false;
                            });
                          }
                        }
                      },
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
    _dateCtl.text = _dateCtl.text != ''
        ? _dateCtl.text
        : widget.profile != null
            ? widget.profile.dob
            : '';

    if (widget.profile != null) {
      widget.authenteqEnabled
          ? Navigator.of(context).pushReplacementNamed(
              '/authenteqVerification',
            )
          : Navigator.of(context).pushReplacementNamed(
              '/accountVerifyDocuments',
            );
    }

    return isDesktop(context)
        ? buildWeb(context)
        : Builder(
            builder: (context) => Container(
              color: Theme.of(context).colorScheme.background,
              child: SingleChildScrollView(
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: (displayHeight(context) * 0.1),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              initialValue: widget.profile != null
                                  ? widget.profile.firstName ?? ''
                                  : null,
                              autocorrect: true,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              onSaved: (str) => _firstName = str,
                              onFieldSubmitted: (str) {
                                setState(
                                  () {
                                    _firstName = str;
                                  },
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return tr('please_fill_field');
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                hintText: tr(
                                  'identity_first_name',
                                ),
                              ),
                            ),
                            SpaceH16(),
                            TextFormField(
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              initialValue: widget.profile != null
                                  ? widget.profile.lastName ?? ''
                                  : null,
                              autocorrect: true,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              onSaved: (str) => _lastName = str,
                              onFieldSubmitted: (str) {
                                setState(
                                  () {
                                    _lastName = str;
                                  },
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return tr('please_fill_field');
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                hintText: tr('identity_last_name'),
                              ),
                            ),
                            SpaceH16(),
                            TextFormField(
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              readOnly: true,
                              controller: _dateCtl,
                              keyboardType: TextInputType.datetime,
                              onTap: () async {
                                DateTime date;
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                date = await showDatePicker(
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return Theme(
                                        data: appTheme().copyWith(
                                          colorScheme: appTheme()
                                              .colorScheme
                                              .copyWith(
                                                  onSurface: onPrimary,
                                                  primary: primaryVariant,
                                                  onPrimary: Colors.white),
                                        ),
                                        child: child,
                                      );
                                    },
                                    context: context,
                                    initialEntryMode:
                                        DatePickerEntryMode.calendar,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1920),
                                    lastDate: DateTime.now());
                                if (date != null) {
                                  _dateCtl.text = date.toString().split(' ')[0];
                                }
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return tr('please_fill_field');
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                hintText: tr('identity_date_of_birth'),
                              ),
                            ),
                            SpaceH16(),
                            CountryCodePicker(
                              initialSelection: widget.profile != null
                                  ? widget.profile.country ?? null
                                  : null,
                              searchStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                              dialogTextStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                              onChanged: (code) {
                                setState(
                                  () {
                                    _countryOfResidence = code.code;
                                  },
                                );
                              },
                              builder: (code) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(
                                        8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: (controlletCountry)
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primaryVariant
                                                : Colors.red),
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            _countryOfResidence != ''
                                                ? CountryCode.fromCode(
                                                    _countryOfResidence,
                                                  ).name
                                                : (widget.profile != null &&
                                                        widget.profile
                                                                .country !=
                                                            null &&
                                                        widget.profile
                                                                .country !=
                                                            '')
                                                    ? CountryCode.fromCode(
                                                          widget
                                                              .profile.country,
                                                        ).name ??
                                                        tr('identity_residence')
                                                    : tr('identity_residence'),
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
                                          ),
                                        ],
                                      ),
                                    ),
                                    (controlletCountry)
                                        ? SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 9, top: 4),
                                            child: Text(tr('please_fill_field'),
                                                style: TextStyle(
                                                  color: Colors.red,
                                                )),
                                          )
                                  ],
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              // optional. Shows only country name and flag
                              showFlag: true,
                              showCountryOnly: true,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: true,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                            SpaceH16(),
                            TextFormField(
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              initialValue: widget.profile != null
                                  ? widget.profile.city ?? null
                                  : null,
                              autocorrect: true,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              onSaved: (str) => _city = str,
                              onFieldSubmitted: (str) {
                                setState(
                                  () {
                                    _city = str;
                                  },
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return tr('please_fill_field');
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                hintText: tr('identity_city'),
                              ),
                            ),
                            SpaceH16(),
                            TextFormField(
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              initialValue: widget.profile != null
                                  ? widget.profile.address ?? null
                                  : null,
                              autocorrect: true,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              onSaved: (str) => _address = str,
                              onFieldSubmitted: (str) {
                                setState(
                                  () {
                                    _address = str;
                                  },
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return tr('please_fill_field');
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                hintText: tr(
                                  'identity_residential_address',
                                ),
                              ),
                            ),
                            SpaceH16(),
                            TextFormField(
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              initialValue: widget.profile != null
                                  ? widget.profile.postcode ?? null
                                  : null,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              onSaved: (str) => _postcode = str,
                              onFieldSubmitted: (str) {
                                setState(
                                  () {
                                    _postcode = str;
                                  },
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return tr('please_fill_field');
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                hintText: tr('identity_postcode'),
                              ),
                            ),
                            SpaceH16(),
                            Flex(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    child: Text(
                                      tr('verify_label'),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText1
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                          ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState.validate() &&
                                          _countryOfResidence.isNotEmpty) {
                                        _formKey.currentState.save();
                                        widget.onUpdateProfile(
                                          _firstName,
                                          _lastName,
                                          _dateCtl.text,
                                          _countryOfResidence,
                                          _city,
                                          _address,
                                          _postcode,
                                        );
                                      } else {
                                        if (_countryOfResidence.isNotEmpty) {
                                          setState(() {
                                            controlletCountry = true;
                                          });
                                        } else if (_countryOfResidence
                                            .isEmpty) {
                                          setState(() {
                                            controlletCountry = false;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
