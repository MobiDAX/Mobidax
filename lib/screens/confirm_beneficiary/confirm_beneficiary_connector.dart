import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';

import 'confirm_beneficiary_widget.dart';

class ConfirmBeneficiaryPageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ConfirmBeneficiaryPageModel>(
      model: ConfirmBeneficiaryPageModel(),
      builder: (BuildContext context, ConfirmBeneficiaryPageModel vm) =>
          ConfirmBeneficiaryPage(
        onConfirmBeneficiary: vm.onConfirmBeneficiary,
        createdBeneficiary: vm.createdBeneficiary,
      ),
    );
  }
}
