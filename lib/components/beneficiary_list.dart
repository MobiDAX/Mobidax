import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'spacers.dart';
import 'package:mobidax_redux/account/account_state.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/types.dart';
import 'package:mobidax_redux/wallet/wallet_model.dart';

import '../helpers/dialog_components.dart';
import '../helpers/error_notifier.dart';
import '../helpers/sizes_helpers.dart';
import '../web/components/form.dart';
import '../web/components/modal_header.dart';
import 'modal_window.dart';

class BeneficiaryListWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: isDesktop(context)
          ? null
          : FloatingActionButton(
              child: const Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/createBeneficiary',
                );
              },
            ),
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
                tr('beneficiary_page_title'),
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
          BeneficiaryListConnector(),
        ],
      ),
    );
  }
}

class BeneficiaryList extends StatelessWidget {
  BeneficiaryList(
      {this.beneficiaries,
      this.selectedCardIndex,
      this.onFetchBeneficiary,
      this.onBeneficiarySelect,
      this.onDeleteBeneficiary});

  final List<Beneficiary> beneficiaries;
  final int selectedCardIndex;
  final Function(Beneficiary beneficiary) onBeneficiarySelect;
  final Function onFetchBeneficiary;
  final Function onDeleteBeneficiary;

  Widget buildWeb(BuildContext context) {
    return FormComponent(
      bgColor: Theme.of(context).colorScheme.background,
      heading: ModalHeader(
        title: tr(
          'beneficiary_page_title',
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Column(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true, // use it
                itemCount: beneficiaries.length,
                itemBuilder: (context, i) {
                  var item = beneficiaries[i];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    child: InkWell(
                      onTap: () {
                        if (item.state == 'active') {
                          onBeneficiarySelect(item);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                item.currency.toUpperCase(),
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 11,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  item.name,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText2
                                      .copyWith(
                                        fontSize: 11,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: item.state == 'active'
                                      ? const Icon(
                                          Icons.check,
                                          size: 25,
                                          color: Colors.lightGreen,
                                        )
                                      : Icon(
                                          Icons.autorenew_outlined,
                                          size: 25,
                                          color: Colors.orange,
                                        ),
                                ),
                              ),
                            ),
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ModalWindow(
                                      titleName: tr('beneficiary_page_title'),
                                      content: InfoDialog(
                                        dict: {
                                          tr('identity_first_name'): item.name,
                                          tr('withdrawal_address'):
                                              item.address,
                                          tr('description_label'):
                                              item.description,
                                          tr('state'): item.state,
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.error_outline,
                                  size: 25,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Container(
                                child: GestureDetector(
                                    onTap: () {
                                      onDeleteBeneficiary(item.id);
                                    },
                                    child: Icon(Icons.clear)),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            SpaceH16(),
            ElevatedButton(
              child: Text(
                tr('add_benef_button_label'),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/createBeneficiary');
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isDesktop(context)
        ? buildWeb(context)
        : RefreshIndicator(
            color: Theme.of(context).accentColor,
            backgroundColor: Theme.of(context).colorScheme.background,
            onRefresh: () async {
              onFetchBeneficiary();
            },
            child: ListView.builder(
              itemCount: beneficiaries.length,
              itemBuilder: (context, i) {
                var item = beneficiaries[i];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  child: InkWell(
                    onTap: () {
                      if (item.state == 'active') {
                        onBeneficiarySelect(item);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              item.id.toString(),
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText2
                                  .copyWith(
                                    fontSize: 11,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.currency.toUpperCase(),
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText2
                                  .copyWith(
                                    fontSize: 11,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.2,
                              ),
                              child: Text(
                                item.name,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 11,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: GestureDetector(
                                onTap: () {},
                                child: item.state == 'active'
                                    ? const Icon(
                                        Icons.check,
                                        size: 25,
                                        color: Colors.lightGreen,
                                      )
                                    : Icon(Icons.autorenew_outlined,
                                        size: 25, color: Colors.orange),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ModalWindow(
                                      titleName: tr('beneficiary_page_title'),
                                      content: InfoDialog(
                                        dict: {
                                          tr('identity_first_name'): item.name,
                                          tr('withdrawal_address'):
                                              item.address,
                                          tr('description_label'):
                                              item.description,
                                          tr('state'): item.state,
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.error_outline,
                                  size: 25,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Container(
                                child: GestureDetector(
                                    onTap: () {
                                      onDeleteBeneficiary(item.id);
                                    },
                                    child: Icon(Icons.clear)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}

class BeneficiaryListConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WalletPageModel>(
      model: WalletPageModel(),
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
      builder: (BuildContext context, WalletPageModel vm) => BeneficiaryList(
          beneficiaries: vm.beneficiaries
              .where((element) =>
                  element.currency ==
                  vm.balances[vm.selectedCardIndex].currency.id)
              .toList(),
          selectedCardIndex: vm.selectedCardIndex,
          onFetchBeneficiary: vm.onFetchBeneficiary,
          onBeneficiarySelect: vm.onBeneficiarySelect,
          onDeleteBeneficiary: vm.onDeleteBeneficiary),
    );
  }
}
