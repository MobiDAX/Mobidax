import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/spacers.dart';

import '../../helpers/sizes_helpers.dart';
import '../../web/components/form.dart';
import '../../web/components/modal_header.dart';
import 'sign_up_connector.dart';

class SignUp extends StatelessWidget {
  const SignUp({
    this.refId,
  });

  final String refId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: isDesktop(context)
          ? null
          : AppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                tr('sign_up_label'),
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
          SignUpPageConnector(
            refId: this.refId,
          ),
        ],
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    Key key,
    this.onCreateUser,
    this.onSignUpLoading,
    this.signUpLoading,
    this.refId,
  }) : super(key: key);

  final bool signUpLoading;
  final Function onCreateUser;
  final Function onSignUpLoading;
  final String refId;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  String _email, _password, _referralCode = '';
  bool _acceptedTerms = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  Widget buildWeb(BuildContext context) {
    return FormComponent(
      heading: ModalHeader(
        title: tr(
          'sign_up_label',
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
                autofillHints: [AutofillHints.email],
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _email = email,
                onFieldSubmitted: (str) {},
                decoration: InputDecoration(
                  hintText: tr('email_address_label'),
                ),
                validator: (email) {
                  Pattern pattern =
                      r'^([a-zA-Z0-9_\-\.+]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(email))
                    return tr('invalid_email');
                  else
                    return null;
                },
              ),
              SpaceH16(),
              TextFormField(
                autofillHints: [AutofillHints.newPassword],
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                obscureText: !_passwordVisible,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (str) {},
                onSaved: (password) => _password = password,
                textInputAction: TextInputAction.next,
                controller: _pass,
                validator: (password) {
                  Pattern pattern =
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,80}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(password))
                    return tr('password.password.password_strength');
                  else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: tr('password_label'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          _passwordVisible = !_passwordVisible;
                        },
                      );
                    },
                  ),
                ),
              ),
              SpaceH16(),
              TextFormField(
                autofillHints: [AutofillHints.newPassword],
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                obscureText: !_confirmPasswordVisible,
                keyboardType: TextInputType.visiblePassword,
                onFieldSubmitted: (str) {},
                textInputAction: TextInputAction.next,
                validator: (password) {
                  if (password != _pass.value.text || _pass.value.text == null)
                    return tr('identity.user.passwords_doesnt_match');
                  else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: tr('confirm_password_label'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        },
                      );
                    },
                  ),
                ),
              ),
              SpaceH16(),
              TextFormField(
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                obscureText: false,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (str) {},
                initialValue: widget.refId ?? '',
                onSaved: (code) => _referralCode = code,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: tr('referral_code'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: RawMaterialButton(
                  onPressed: () {
                    setState(
                      () {
                        _acceptedTerms = !_acceptedTerms;
                      },
                    );
                  },
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Icon(
                          _acceptedTerms
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tr('terms_and_cond'),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(
                                      _acceptedTerms ? 1 : 0.6,
                                    ),
                              ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
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
                          if (_formKey.currentState.validate() &&
                              _acceptedTerms) {
                            _formKey.currentState.save();
                            widget.onSignUpLoading();
                            widget.onCreateUser(
                                _email, _password, _referralCode);
                            if (_referralCode != widget.refId) {
                              _pass.clear();
                            }
                          }
                        },
                        child: Text(
                          tr('sign_up_label'),
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
    return widget.signUpLoading
        ? Container(
            color: Theme.of(context).colorScheme.background,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.background,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).accentColor,
                ),
              ),
            ),
          )
        : isDesktop(context)
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
                            vertical: displayHeight(context) * 0.1,
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
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: [AutofillHints.email],
                                  onSaved: (email) => _email = email,
                                  onFieldSubmitted: (str) {
                                    TextInput.finishAutofillContext(
                                      shouldSave: true,
                                    );
                                  },
                                  decoration: InputDecoration(
                                    hintText: tr('email_address_label'),
                                  ),
                                  validator: (email) {
                                    Pattern pattern =
                                        r'^([a-zA-Z0-9_\-\.+]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
                                    RegExp regex = RegExp(pattern);
                                    if (!regex.hasMatch(email))
                                      return tr('invalid_email');
                                    else
                                      return null;
                                  },
                                ),
                                SpaceH16(),
                                TextFormField(
                                  cursorColor: Theme.of(context)
                                      .textSelectionTheme
                                      .cursorColor,
                                  obscureText: !_passwordVisible,
                                  keyboardType: TextInputType.text,
                                  autofillHints: [AutofillHints.newPassword],
                                  onFieldSubmitted: (str) {},
                                  onSaved: (password) {
                                    TextInput.finishAutofillContext(
                                        shouldSave: true);
                                    _password = password;
                                  },
                                  textInputAction: TextInputAction.done,
                                  controller: _pass,
                                  validator: (password) {
                                    Pattern pattern =
                                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,80}$';
                                    RegExp regex = RegExp(pattern);
                                    if (!regex.hasMatch(password))
                                      return tr(
                                          'password.password.password_strength');
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: tr('password_label'),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SpaceH16(),
                                TextFormField(
                                  cursorColor: Theme.of(context)
                                      .textSelectionTheme
                                      .cursorColor,
                                  obscureText: !_confirmPasswordVisible,
                                  keyboardType: TextInputType.text,
                                  autofillHints: [AutofillHints.newPassword],
                                  onFieldSubmitted: (str) {},
                                  textInputAction: TextInputAction.done,
                                  validator: (password) {
                                    if (password != _pass.value.text ||
                                        _pass.value.text == null)
                                      return tr(
                                          'identity.user.passwords_doesnt_match');
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: tr('confirm_password_label'),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _confirmPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () {
                                            _confirmPasswordVisible =
                                                !_confirmPasswordVisible;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SpaceH16(),
                                TextFormField(
                                  cursorColor: Theme.of(context)
                                      .textSelectionTheme
                                      .cursorColor,
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  onFieldSubmitted: (str) {},
                                  initialValue: widget.refId ?? '',
                                  onSaved: (code) => _referralCode = code,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText: tr(
                                      'referral_code',
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      setState(
                                        () {
                                          _acceptedTerms = !_acceptedTerms;
                                        },
                                      );
                                    },
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Icon(
                                            _acceptedTerms
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            tr('terms_and_cond'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground
                                                      .withOpacity(
                                                        _acceptedTerms
                                                            ? 1
                                                            : 0.6,
                                                      ),
                                                ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Flex(
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                    .validate() &&
                                                _acceptedTerms) {
                                              _formKey.currentState.save();
                                              widget.onSignUpLoading();
                                              widget.onCreateUser(_email,
                                                  _password, _referralCode);
                                              if (_referralCode !=
                                                  widget.refId) {
                                                _pass.clear();
                                              }
                                            }
                                          },
                                          child: Text(
                                            tr('sign_up_label'),
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
                      ],
                    ),
                  ),
                ),
              );
  }
}
