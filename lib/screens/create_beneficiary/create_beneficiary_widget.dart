import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';

import '../../components/account_screen_inputs.dart';
import '../../components/spacers.dart';
import '../../helpers/sizes_helpers.dart';
import '../../web/components/form.dart';
import '../../web/components/modal_header.dart';
import 'create_beneficiary_connector.dart';

class CreateBeneficiaryWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: isDesktop(context)
          ? null
          : AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: true,
              title: Text(
                tr(
                  'beneficiary_page_title',
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
          CreateBeneficiaryPageConnector(),
        ],
      ),
    );
  }
}

class CreateBeneficiaryPage extends StatefulWidget {
  const CreateBeneficiaryPage({
    this.onCreateBeneficiary,
    this.onCreateFiatBeneficiary,
    this.loading,
    this.currency,
  });

  final Function(
          String address, String description, String name, String currency)
      onCreateBeneficiary;
  final Function(String name, String fullName, String accountNumber,
      String bankName, String currency) onCreateFiatBeneficiary;
  final bool loading;
  final CurrencyItemState currency;

  @override
  _CreateBeneficiaryPageState createState() => _CreateBeneficiaryPageState();
}

class _CreateBeneficiaryPageState extends State<CreateBeneficiaryPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final fullNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final bankNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    fullNameController.dispose();
    accountNumberController.dispose();
    bankNameController.dispose();
    super.dispose();
  }

  Widget buildWeb(BuildContext context) {
    return FormComponent(
      bgColor: Theme.of(context).colorScheme.background,
      heading: ModalHeader(
        title: tr(
          'add_benef_button_label',
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpaceH4(),
                TextFormField(
                  cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                  validator: (str) {
                    if (str.isEmpty) {
                      return tr('benef_name_not_empty');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: tr(
                      'benef_name',
                    ),
                  ),
                  controller: nameController,
                ),
                SpaceH15(),
                widget.currency.type == 'fiat'
                    ? TextFormField(
                        cursorColor:
                            Theme.of(context).textSelectionTheme.cursorColor,
                        validator: (str) {
                          if (str.isEmpty) {
                            return tr(
                              'fullname_not_empty',
                            );
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: tr(
                            'full_name',
                          ),
                        ),
                        controller: fullNameController,
                      )
                    : TextFormField(
                        cursorColor:
                            Theme.of(context).textSelectionTheme.cursorColor,
                        validator: (str) {
                          if (str.isEmpty) {
                            return tr(
                              'block_name_not_empty',
                            );
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: tr(
                            'block_addr',
                          ),
                        ),
                        controller: addressController,
                      ),
                SpaceH15(),
                widget.currency.type == "fiat"
                    ? TextFormField(
                        cursorColor:
                            Theme.of(context).textSelectionTheme.cursorColor,
                        validator: (str) {
                          if (str.isEmpty) {
                            return tr(
                              'account_num_not_empty',
                            );
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: tr(
                            'account_num',
                          ),
                        ),
                        controller: accountNumberController,
                      )
                    : TextFormField(
                        cursorColor:
                            Theme.of(context).textSelectionTheme.cursorColor,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: tr(
                            'desc',
                          ),
                        ),
                        controller: descriptionController,
                      ),
                SpaceH15(),
                widget.currency.type == "fiat"
                    ? TextFormField(
                        cursorColor:
                            Theme.of(context).textSelectionTheme.cursorColor,
                        validator: (str) {
                          if (str.isEmpty) {
                            return tr(
                              'bank_name_not_empty',
                            );
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: tr(
                            'bank_name',
                          ),
                        ),
                        controller: bankNameController,
                      )
                    : Container(),
                widget.currency.type == 'fiat' ? SpaceH15() : Container(),
                AccountButton(
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  text: tr('withdraw_create'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if (widget.currency.type == 'fiat') {
                        widget.onCreateFiatBeneficiary(
                          nameController.text,
                          fullNameController.text,
                          accountNumberController.text,
                          bankNameController.text,
                          widget.currency.id,
                        );
                      } else {
                        widget.onCreateBeneficiary(
                          addressController.text,
                          descriptionController.text,
                          nameController.text,
                          widget.currency.id,
                        );
                      }
                    }
                  },
                )
              ],
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
        : widget.loading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor,
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        tr(
                          'add_benef_button_label',
                        ),
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      SpaceH15(),
                      TextFormField(
                        cursorColor:
                            Theme.of(context).textSelectionTheme.cursorColor,
                        validator: (str) {
                          if (str.isEmpty) {
                            return tr(
                              'benef_name_not_empty',
                            );
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: tr(
                            'benef_name',
                          ),
                        ),
                        controller: nameController,
                      ),
                      SpaceH15(),
                      widget.currency.type == 'fiat'
                          ? TextFormField(
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              validator: (str) {
                                if (str.isEmpty) {
                                  return tr(
                                    'fullname_not_empty',
                                  );
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: tr(
                                  'full_name',
                                ),
                              ),
                              controller: fullNameController,
                            )
                          : TextFormField(
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              validator: (str) {
                                if (str.isEmpty) {
                                  return tr(
                                    'block_name_not_empty',
                                  );
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: tr(
                                  'block_addr',
                                ),
                              ),
                              controller: addressController,
                            ),
                      SpaceH15(),
                      widget.currency.type == 'fiat'
                          ? TextFormField(
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              validator: (str) {
                                if (str.isEmpty) {
                                  return tr('account_num_not_empty');
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: tr(
                                  'account_num',
                                ),
                              ),
                              controller: accountNumberController,
                            )
                          : TextFormField(
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: tr(
                                  'desc',
                                ),
                              ),
                              controller: descriptionController,
                            ),
                      SpaceH15(),
                      widget.currency.type == 'fiat'
                          ? TextFormField(
                              cursorColor: Theme.of(context)
                                  .textSelectionTheme
                                  .cursorColor,
                              validator: (str) {
                                if (str.isEmpty) {
                                  return tr(
                                    'bank_name_not_empty',
                                  );
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: tr(
                                  'bank_name',
                                ),
                              ),
                              controller: bankNameController,
                            )
                          : Container(),
                      widget.currency.type == 'fiat' ? SpaceH15() : Container(),
                      AccountButton(
                        textColor: Theme.of(context).colorScheme.onSecondary,
                        text: tr('withdraw_create'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (widget.currency.type == "fiat") {
                              widget.onCreateFiatBeneficiary(
                                nameController.text,
                                fullNameController.text,
                                accountNumberController.text,
                                bankNameController.text,
                                widget.currency.id,
                              );
                            } else {
                              widget.onCreateBeneficiary(
                                addressController.text,
                                descriptionController.text,
                                nameController.text,
                                widget.currency.id,
                              );
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
  }
}
