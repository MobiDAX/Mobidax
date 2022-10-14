import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/account/account_model.dart';
import 'package:mobidax_redux/store.dart';
import 'package:mobidax_redux/types.dart';

import '../helpers/error_notifier.dart';
import '../helpers/sizes_helpers.dart';
import '../web/components/form.dart';
import '../web/components/modal_header.dart';
import 'spacers.dart';

class AccountScreenChangePasswordWrapper extends StatelessWidget {
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
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: true,
              title: Text(
                tr('change_password_label'),
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
          AccountScreenChangePasswordConnector(),
        ],
      ),
    );
  }
}

class AccountScreenChangePassword extends StatefulWidget {
  const AccountScreenChangePassword({
    this.onChangePassword,
  });

  final Function(String oldPassword, String newPassword, String confirmPassword)
      onChangePassword;

  @override
  _AccountScreenChangePasswordState createState() =>
      _AccountScreenChangePasswordState();
}

class _AccountScreenChangePasswordState
    extends State<AccountScreenChangePassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _currentPasswordVisible = false;
  bool _confirmNewPasswordVisible = false;
  bool _newPasswordVisible = false;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget buildWeb(BuildContext context) {
    return FormComponent(
      heading: ModalHeader(
        title: tr('change_password_label'),
      ),
      content: Form(
        key: _formKey,
        child: Container(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(
                left: 50,
                right: 50,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextFormField(
                          cursorColor:
                              Theme.of(context).textSelectionTheme.cursorColor,
                          obscureText: !_currentPasswordVisible,
                          keyboardType: TextInputType.text,
                          controller: oldPasswordController,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: tr(
                              'current_password_label',
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _currentPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    _currentPasswordVisible =
                                        !_currentPasswordVisible;
                                  },
                                );
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return tr('please_fill_field');
                            } else
                              return null;
                          },
                        ),
                        SpaceH16(),
                        TextFormField(
                          cursorColor:
                              Theme.of(context).textSelectionTheme.cursorColor,
                          obscureText: !_newPasswordVisible,
                          keyboardType: TextInputType.text,
                          controller: newPasswordController,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: tr(
                              'new_password_label',
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
                                    _newPasswordVisible = !_newPasswordVisible;
                                  },
                                );
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return tr('please_fill_field');
                            } else
                              return null;
                          },
                        ),
                        SpaceH16(),
                        TextFormField(
                          cursorColor:
                              Theme.of(context).textSelectionTheme.cursorColor,
                          obscureText: !_confirmNewPasswordVisible,
                          keyboardType: TextInputType.text,
                          controller: confirmPasswordController,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: tr(
                              'confirm_new_password_label',
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmNewPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    _confirmNewPasswordVisible =
                                        !_confirmNewPasswordVisible;
                                  },
                                );
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return tr('please_fill_field');
                            } else
                              return null;
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 10),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                tr('change_password_label'),
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
                                if (_formKey.currentState.validate()) {
                                  widget.onChangePassword(
                                    oldPasswordController.text,
                                    newPasswordController.text,
                                    confirmPasswordController.text,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isDesktop(context)
        ? buildWeb(context)
        : Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  TextFormField(
                                    cursorColor: Theme.of(context)
                                        .textSelectionTheme
                                        .cursorColor,
                                    obscureText: !_currentPasswordVisible,
                                    keyboardType: TextInputType.text,
                                    controller: oldPasswordController,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      hintText: tr(
                                        'current_password_label',
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _currentPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(
                                            () {
                                              _currentPasswordVisible =
                                                  !_currentPasswordVisible;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return tr('please_fill_field');
                                      } else
                                        return null;
                                    },
                                  ),
                                  SpaceH16(),
                                  TextFormField(
                                    cursorColor: Theme.of(context)
                                        .textSelectionTheme
                                        .cursorColor,
                                    obscureText: !_newPasswordVisible,
                                    keyboardType: TextInputType.text,
                                    controller: newPasswordController,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      hintText: tr('new_password_label'),
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
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return tr('please_fill_field');
                                      } else
                                        return null;
                                    },
                                  ),
                                  SpaceH16(),
                                  TextFormField(
                                    cursorColor: Theme.of(context)
                                        .textSelectionTheme
                                        .cursorColor,
                                    obscureText: !_confirmNewPasswordVisible,
                                    keyboardType: TextInputType.text,
                                    controller: confirmPasswordController,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      hintText:
                                          tr('confirm_new_password_label'),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _confirmNewPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(
                                            () {
                                              _confirmNewPasswordVisible =
                                                  !_confirmNewPasswordVisible;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return tr('please_fill_field');
                                      } else
                                        return null;
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 10),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        child: Text(
                                          tr('change_password_label'),
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
                                          if (_formKey.currentState
                                              .validate()) {
                                            widget.onChangePassword(
                                              oldPasswordController.text,
                                              newPasswordController.text,
                                              confirmPasswordController.text,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}

class AccountScreenChangePasswordConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      onWillChange: (vm) {
        if (vm.error != null) {
          vm.clearError();
          SnackBarNotifier.createSnackBar(
            '${tr(vm.error.graphqlErrors.first.message)}.' ??
                'Something went wrong',
            context,
            Status.error,
          );
        }
      },
      builder: (BuildContext context, AccountPageModel vm) =>
          AccountScreenChangePassword(
        onChangePassword: vm.onChangePassword,
      ),
    );
  }
}
