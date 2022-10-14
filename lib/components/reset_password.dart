import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/account/account_model.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';

import '../helpers/error_notifier.dart';
import '../helpers/sizes_helpers.dart';
import '../web/components/form.dart';
import '../web/components/modal_header.dart';
import 'spacers.dart';

class ResetPasswordWrapper extends StatelessWidget {
  const ResetPasswordWrapper({
    this.resetToken,
  });

  final String resetToken;

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
              title: (resetToken == null)
                  ? Text(
                      tr('password_reset_label'),
                      style:
                          Theme.of(context).primaryTextTheme.headline6.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                    )
                  : Text(
                      tr('create_new_password_label'),
                      style:
                          Theme.of(context).primaryTextTheme.headline6.copyWith(
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
          ResetPasswordConnector(
            resetToken: resetToken,
          ),
        ],
      ),
    );
  }
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({
    this.onAskPasswordReset,
    this.onResetPassword,
    this.resetToken,
  });

  final String resetToken;
  final Function(String) onAskPasswordReset;
  final Function(String, String, String) onResetPassword;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password = "";
  final TextEditingController _pass = TextEditingController();
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  Widget buildWeb(BuildContext context, token) {
    return FormComponent(
      heading: ModalHeader(
        title: token == null
            ? tr('password_reset_label')
            : tr('create_new_password_label'),
      ),
      content: token == null
          ? Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      cursorColor:
                          Theme.of(context).textSelectionTheme.cursorColor,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (email) => _email = email,
                      onFieldSubmitted: (str) {},
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
                                  widget.onAskPasswordReset(_email);
                                }
                              },
                              child: Text(
                                tr(
                                  'reset_password_button',
                                ),
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
            )
          : Padding(
              padding: const EdgeInsets.all(
                32.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      cursorColor:
                          Theme.of(context).textSelectionTheme.cursorColor,
                      keyboardType: TextInputType.text,
                      obscureText: !_newPasswordVisible,
                      onFieldSubmitted: (str) {},
                      onSaved: (password) => _password = password,
                      textInputAction: TextInputAction.done,
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
                            _newPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                _newPasswordVisible = !_newPasswordVisible;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SpaceH16(),
                    TextFormField(
                      cursorColor:
                          Theme.of(context).textSelectionTheme.cursorColor,
                      obscureText: !_confirmPasswordVisible,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (str) {},
                      textInputAction: TextInputAction.done,
                      validator: (password) {
                        if (password != _pass.value.text ||
                            _pass.value.text == null)
                          return tr('identity.user.passwords_doesnt_match');
                        else
                          return null;
                      },
                      decoration: InputDecoration(
                        hintText: tr(
                          'confirm_password_label',
                        ),
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
                                  widget.onResetPassword(
                                    _password,
                                    _password,
                                    token,
                                  );
                                }
                              },
                              child: Text(
                                tr(
                                  'set_new_password',
                                ),
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

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    var token = args != null ? args['token'] : widget.resetToken;

    return isDesktop(context)
        ? buildWeb(context, token)
        : Builder(
            builder: (BuildContext context) {
              return token == null
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
                                    keyboardType: TextInputType.emailAddress,
                                    onSaved: (email) => _email = email,
                                    onFieldSubmitted: (str) {},
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
                                              if (_formKey.currentState
                                                  .validate()) {
                                                _formKey.currentState.save();
                                                widget
                                                    .onAskPasswordReset(_email);
                                              }
                                            },
                                            child: Text(
                                              tr(
                                                'reset_password_button',
                                              ),
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
                        ),
                      ],
                    )
                  : Flex(
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
                                    obscureText: !_newPasswordVisible,
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (str) {},
                                    onSaved: (password) => _password = password,
                                    textInputAction: TextInputAction.done,
                                    controller: _pass,
                                    validator: (password) {
                                      Pattern pattern =
                                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,80}$';
                                      RegExp regex = RegExp(pattern);
                                      if (!regex.hasMatch(password))
                                        return tr(
                                          'password.password.password_strength',
                                        );
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: tr(
                                        'password_label',
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _newPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(
                                            () {
                                              _newPasswordVisible =
                                                  !_newPasswordVisible;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SpaceH16(),
                                  TextFormField(
                                    obscureText: !_confirmPasswordVisible,
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (str) {},
                                    cursorColor: Theme.of(context)
                                        .textSelectionTheme
                                        .cursorColor,
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
                                      hintText: tr(
                                        'confirm_password_label',
                                      ),
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
                                              if (_formKey.currentState
                                                  .validate()) {
                                                _formKey.currentState.save();
                                                widget.onResetPassword(
                                                  _password,
                                                  _password,
                                                  token,
                                                );
                                              }
                                            },
                                            child: Text(
                                              tr(
                                                'set_new_password',
                                              ),
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
                        ),
                      ],
                    );
            },
          );
  }
}

class ResetPasswordConnector extends StatelessWidget {
  const ResetPasswordConnector({
    this.resetToken,
  });
  final String resetToken;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      onWillChange: (vm) {
        vm.clearError();
        if (vm.error != null) {
          SnackBarNotifier.createSnackBar(
            tr(vm.error.graphqlErrors.first.message) ?? 'Something went wrong',
            context,
            Status.error,
          );
        }
      },
      builder: (BuildContext context, AccountPageModel vm) => ResetPassword(
        resetToken: resetToken,
        onResetPassword: vm.onResetPassword,
        onAskPasswordReset: vm.onAskPasswordReset,
      ),
    );
  }
}
