import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/store.dart';
import 'package:mobidax_redux/types.dart';

import '../../helpers/error_notifier.dart';
import 'sign_in_widget.dart';

class SignInPageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SignInPageModel>(
      model: SignInPageModel(),
      onInit: (st) {
        st.dispatch(
          ClearStateAction(),
        );
      },
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
      builder: (BuildContext context, SignInPageModel vm) => SignInPage(
        onAuthenticate: vm.onAuthenticate,
        onSignInLoading: vm.onSignInLoading,
        signInLoading: vm.signInLoading,
        error: vm.error != null
            ? tr(vm.error.graphqlErrors.first.message) ?? 'Something went wrong'
            : null,
        enabled2FA: vm.enabled2FA,
      ),
    );
  }
}
