import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/otp_code.dart';
import '../../components/spacers.dart';
import '../../helpers/sizes_helpers.dart';
import '../../web/components/form.dart';
import '../../web/components/modal_header.dart';
import 'sign_in_connector.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isDesktop(context)
          ? null
          : AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 0.0,
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
                tr('sign_in_label'),
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
      backgroundColor: Theme.of(context).colorScheme.primary,
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
          SignInPageConnector()
        ],
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({
    Key key,
    this.onAuthenticate,
    this.onClickForgotPassword,
    this.onSignInLoading,
    this.signInLoading,
    this.error,
    this.enabled2FA,
  }) : super(key: key);

  final String error;
  final bool signInLoading;
  final bool enabled2FA;
  final Function onAuthenticate;
  final Function onClickForgotPassword;
  final Function onSignInLoading;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password = '';
  bool _passwordVisible = false;

  Widget buildWeb(BuildContext context) {
    return FormComponent(
      heading: ModalHeader(
        title: tr(
          'sign_in_label',
        ),
      ),
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: widget.enabled2FA
              ? Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'assets/icons/google_authentication_phone.png',
                      ),
                    ),
                    SpaceW16(),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          //SpaceH48(),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: tr('2fa_hint'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                ),
                                TextSpan(
                                  text: ' ' + tr('google_authenticator') + ' ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextSpan(
                                  text: tr('2fa_hint_pt2'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          /*Text(
                            tr('enter_2fa'),
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground,
                                ),
                          ),*/
                          //SpaceH48(),
                          OtpField(
                            bgColor: Theme.of(context).colorScheme.primary,
                            onVerifyOTP: (String value) {
                              widget.onSignInLoading();
                              widget.onAuthenticate(
                                _email,
                                _password,
                                value,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    //SpaceH48(),
                    TextFormField(
                      cursorColor:
                          Theme.of(context).textSelectionTheme.cursorColor,
                      // textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (email) => _email = email,
                      onFieldSubmitted: (str) {},
                      autofillHints: [AutofillHints.email],
                      decoration: InputDecoration(
                        hintText: tr(
                          'email_address_label',
                        ),
                      ),
                      validator: (email) {
                        Pattern pattern =
                            r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(email))
                          return tr('invalid_email');
                        else
                          return null;
                      },
                    ),
                    SpaceH16(),
                    TextFormField(
                      cursorColor:
                          Theme.of(context).textSelectionTheme.cursorColor,
                      obscureText: !_passwordVisible,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (str) {},
                      onSaved: (password) => _password = password,
                      autofillHints: [AutofillHints.newPassword],
                      textInputAction: TextInputAction.done,
                      validator: (password) {
                        if (password == '' || password == null)
                          return tr('invalid_password');
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  widget.onSignInLoading();
                                  widget.onAuthenticate(
                                    _email,
                                    _password,
                                    '',
                                  );
                                }
                              },
                              child: Text(
                                tr('sign_in_label'),
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/resetPassword');
                        },
                        constraints: const BoxConstraints(),
                        child: Text(
                          tr('forgot_password_label'),
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodyText2
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tr(
                            'dont_have_account',
                          ),
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        SpaceW4(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/signUpPage');
                          },
                          child: Text(
                            tr(
                              'sign_up_label',
                            ),
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  decoration: TextDecoration.underline,
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
    return widget.signInLoading
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
                  child: !widget.enabled2FA
                      ? Flex(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
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
                                        // textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onSaved: (email) => _email = email,
                                        onFieldSubmitted: (str) {},
                                        autofillHints: [AutofillHints.email],
                                        decoration: InputDecoration(
                                          hintText: tr(
                                            'email_address_label',
                                          ),
                                        ),
                                        validator: (email) {
                                          Pattern pattern =
                                              r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+';
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
                                        autofillHints: [
                                          AutofillHints.newPassword
                                        ],
                                        onFieldSubmitted: (str) {},
                                        onSaved: (password) =>
                                            _password = password,
                                        textInputAction: TextInputAction.done,
                                        validator: (password) {
                                          if (password == '' ||
                                              password == null)
                                            return tr('invalid_password');
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
                                      Flex(
                                        direction: Axis.horizontal,
                                        children: <Widget>[
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  _formKey.currentState.save();
                                                  widget.onSignInLoading();
                                                  widget.onAuthenticate(
                                                    _email,
                                                    _password,
                                                    '',
                                                  );
                                                }
                                              },
                                              child: Text(
                                                tr(
                                                  'sign_in_label',
                                                ),
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  '/signUpPage');
                                        },
                                        child: Text(
                                          tr('sign_up_label'),
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyText1
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                        ),
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/resetPassword');
                                          },
                                          constraints: const BoxConstraints(),
                                          child: Text(
                                            tr('forgot_password_label'),
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .bodyText2
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                tr('enter_2fa'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                              ),
                              OtpField(
                                onVerifyOTP: (String value) {
                                  widget.onSignInLoading();
                                  widget.onAuthenticate(
                                    _email,
                                    _password,
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
}
