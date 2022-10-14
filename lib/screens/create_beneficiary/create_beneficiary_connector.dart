import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';

import '../../helpers/error_notifier.dart';
import 'create_beneficiary_widget.dart';

class CreateBeneficiaryPageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateBeneficiaryPageModel>(
      model: CreateBeneficiaryPageModel(),
      builder: (BuildContext context, CreateBeneficiaryPageModel vm) =>
          CreateBeneficiaryPage(
        onCreateBeneficiary: vm.onCreateBeneficiary,
        currency: vm.currency,
        loading: vm.loading,
        onCreateFiatBeneficiary: vm.onCreateFiatBeneficiary,
      ),
    );
  }
}
