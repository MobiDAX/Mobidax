import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/sign_up/sign_up_model.dart';
import 'package:mobidax_redux/types.dart';

import '../../helpers/error_notifier.dart';
import 'sign_up_widget.dart';

class SignUpPageConnector extends StatelessWidget {
  const SignUpPageConnector({
    this.refId,
  });

  final String refId;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SignUpPageModel>(
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
      model: SignUpPageModel(),
      builder: (BuildContext context, SignUpPageModel vm) => SignUpPage(
        onSignUpLoading: vm.onSignUpLoading,
        signUpLoading: vm.signUpLoading,
        onCreateUser: vm.onCreateUser,
        refId: refId,
      ),
    );
  }
}
