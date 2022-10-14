import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/enable_2fa/enable_2fa_actions.dart';
import 'package:mobidax_redux/enable_2fa/enable_2fa_model.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';

import '../../helpers/error_notifier.dart';
import 'enable_2fa_widget.dart';

class Enable2FAConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Enable2FAPageModel>(
      onInit: (st) {
        st.dispatch(GetSecret());
      },
      onWillChange: (vm) {
        vm.clearError();
        if (vm.accountError != null) {
          SnackBarNotifier.createSnackBar(
            tr(vm.accountError.graphqlErrors.first.message) ??
                'Something went wrong',
            context,
            Status.error,
          );
        }
      },
      model: Enable2FAPageModel(),
      builder: (BuildContext context, Enable2FAPageModel vm) => Enable2FAPage(
        onVerifyOTP: vm.onVerifyOTP,
        secret: vm.secret,
        enabled2FA: vm.enabled2FA,
        userName: vm.userName,
      ),
    );
  }
}
