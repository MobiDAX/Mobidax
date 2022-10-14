import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobidax_redux/account/account_model.dart';
import 'package:mobidax_redux/redux.dart';
import 'package:mobidax_redux/store.dart';
import 'package:mobidax_redux/types.dart';

import '../helpers/color_helper.dart';
import '../helpers/error_notifier.dart';
import '../helpers/sizes_helpers.dart';
import '../utils/config.dart';
import '../utils/theme.dart';
import '../web/components/form.dart';
import '../web/components/modal_header.dart';
import 'spacers.dart';

class AccountScreenVerifyDocumentsWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isDesktop(context)
          ? null
          : AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                tr(
                  'documents_verification_label',
                ),
              ),
            ),
      backgroundColor: Theme.of(context).colorScheme.background,
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
          AccountScreenVerifyDocumentsConnector(),
        ],
      ),
    );
  }
}

class AccountScreenVerifyDocuments extends StatefulWidget {
  const AccountScreenVerifyDocuments({
    this.onUploadDoc,
    this.user,
  });

  final Function onUploadDoc;
  final UserState user;

  @override
  _AccountScreenVerifyDocumentsState createState() =>
      _AccountScreenVerifyDocumentsState();
}

class _AccountScreenVerifyDocumentsState
    extends State<AccountScreenVerifyDocuments> {
  TextEditingController dateCtl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  String _docType;
  String _docNumber;

  List<PickedFile> _uploadedImages = [];
  final picker = ImagePicker();
  var docTypes = documentTypes.entries
      .map((e) => DropdownMenuItem<String>(
            value: e.key,
            child: Text(e.value),
          ))
      .toList();

  Future getCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (_uploadedImages.length < 5) {
      if (pickedFile != null) {
        setState(
          () {
            _uploadedImages.add(pickedFile);
          },
        );
      }
    }
  }

  Future getGallery() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (_uploadedImages.length < 5) {
      if (pickedFile != null) {
        setState(
          () {
            _uploadedImages.add(pickedFile);
          },
        );
      }
    }
  }

  Widget buildWeb(BuildContext context) {
    return FormComponent(
      heading: ModalHeader(
        title: tr('documents_verification_label'),
      ),
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  hint: Text(
                    tr('document_type'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  isDense: true,
                  value: _docType,
                  focusColor: Theme.of(context).colorScheme.primaryVariant,
                  iconEnabledColor:
                      Theme.of(context).colorScheme.primaryVariant,
                  elevation: 0,
                  items: docTypes,
                  onChanged: (value) {
                    setState(
                      () {
                        _docType = value;
                      },
                    );
                  },
                  validator: (value) => value == null
                      ? tr(
                          'resource.documents.empty_doc_type',
                        )
                      : null,
                ),
              ),
              SpaceH16(),
              TextFormField(
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (number) {
                  setState(
                    () {
                      _docNumber = number;
                    },
                  );
                },
                onSaved: (number) {
                  setState(
                    () {
                      _docNumber = number;
                    },
                  );
                },
                onChanged: (number) {
                  setState(
                    () {
                      _docNumber = number;
                    },
                  );
                },
                textInputAction: TextInputAction.done,
                validator: (number) {
                  if (number.isEmpty)
                    return tr('resource.documents.empty_doc_number');
                  else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: tr('document_number'),
                ),
              ),
              SpaceH16(),
              TextFormField(
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                readOnly: true,
                controller: dateCtl,
                keyboardType: TextInputType.datetime,
                validator: (number) {
                  if (number.isEmpty)
                    return tr('resource.documents.empty_doc_expire');
                  else
                    return null;
                },
                onTap: () async {
                  DateTime date;
                  FocusScope.of(context).requestFocus(
                    FocusNode(),
                  );
                  date = await showDatePicker(
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: appTheme().copyWith(
                          colorScheme: appTheme().colorScheme.copyWith(
                                onSurface: onPrimary,
                                primary: primaryVariant,
                                onPrimary: Colors.white,
                              ),
                        ),
                        child: child,
                      );
                    },
                    errorInvalidText: tr(
                      'resource.documents.empty_doc_expire',
                    ),
                    context: context,
                    initialEntryMode: DatePickerEntryMode.calendar,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(
                      2050,
                    ),
                  );
                  dateCtl.text = date != null
                      ? date.toString().split(' ')[0]
                      : dateCtl.text;
                },
                decoration: InputDecoration(
                  hintText: tr(
                    'document_expiration_date',
                  ),
                ),
              ),
              SpaceH32(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                      right: 4,
                    ),
                    padding: const EdgeInsets.all(
                      2,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    child: IconButton(
                      onPressed: _uploadedImages.length < 5 ? getGallery : null,
                      icon: Icon(
                        Icons.attachment,
                        size: 25,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                  SpaceW4(),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          tr('document_upload_cta'),
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        Text(
                          tr('document_upload_first_instruction'),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        Text(
                          tr('document_upload_second_instruction'),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SpaceH16(),
              Column(
                children: List.generate(
                  _uploadedImages.length,
                  (index) => Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _uploadedImages[index] != null
                              ? _uploadedImages[index].path.split('/').last
                              : "",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                        ),
                        onPressed: () {
                          setState(
                            () {
                              _uploadedImages.removeAt(index);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: ElevatedButton(
                        child: Text(
                          tr(
                            'phone_verification_button',
                          ),
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (_uploadedImages.isNotEmpty) {
                              setState(
                                () {
                                  _loading = true;
                                },
                              );
                              widget.onUploadDoc(
                                _docType,
                                _docNumber,
                                dateCtl.text,
                                _uploadedImages,
                                () => setState(
                                  () {
                                    _loading = false;
                                  },
                                ),
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: "${tr('Upload document')}",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                webShowClose: true,
                                webPosition: "center",
                                webBgColor: toHex(
                                  Colors.red,
                                ),
                                fontSize: 16.0,
                              );
                            }
                          }
                        },
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
    return _loading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.primary,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            ),
          )
        : isDesktop(context)
            ? buildWeb(context)
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: (displayHeight(context) * 0.1)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                                  style: BorderStyle.solid)),
                          width: double.infinity,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text(
                                tr('document_type'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                              isDense: true,
                              value: _docType,
                              focusColor:
                                  Theme.of(context).colorScheme.primaryVariant,
                              iconEnabledColor:
                                  Theme.of(context).colorScheme.primaryVariant,
                              dropdownColor:
                                  Theme.of(context).colorScheme.primary,
                              elevation: 0,
                              items: docTypes,
                              onChanged: (value) {
                                setState(() {
                                  _docType = value;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          cursorColor:
                              Theme.of(context).textSelectionTheme.cursorColor,
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (number) {
                            setState(() {
                              _docNumber = number;
                            });
                          },
                          onSaved: (number) {
                            setState(() {
                              _docNumber = number;
                            });
                          },
                          onChanged: (number) {
                            setState(() {
                              _docNumber = number;
                            });
                          },
                          textInputAction: TextInputAction.done,
                          validator: (number) {
                            if (number.isEmpty)
                              return tr('resource.documents.empty_doc_number');
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                            hintText: tr('document_number'),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          cursorColor:
                              Theme.of(context).textSelectionTheme.cursorColor,
                          readOnly: true,
                          controller: dateCtl,
                          keyboardType: TextInputType.datetime,
                          validator: (number) {
                            if (number.isEmpty)
                              return tr('resource.documents.empty_doc_expire');
                            else
                              return null;
                          },
                          onTap: () async {
                            DateTime date;
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            date = await showDatePicker(
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: appTheme().copyWith(
                                      colorScheme: appTheme()
                                          .colorScheme
                                          .copyWith(
                                              onSurface: onPrimary,
                                              primary: primaryVariant,
                                              onPrimary: Colors.white),
                                    ),
                                    child: child,
                                  );
                                },
                                errorInvalidText:
                                    tr('resource.documents.empty_doc_expire'),
                                context: context,
                                initialEntryMode: DatePickerEntryMode.calendar,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2050));
                            dateCtl.text = date != null
                                ? date.toString().split(' ')[0]
                                : dateCtl.text;
                          },
                          decoration: InputDecoration(
                            hintText: tr('document_expiration_date'),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 4),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              child: IconButton(
                                onPressed: _uploadedImages.length < 5
                                    ? getGallery
                                    : null,
                                icon: Icon(
                                  Icons.attachment,
                                  size: 25,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    tr('document_upload_cta'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                  ),
                                  Text(
                                    tr('document_upload_first_instruction'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                  ),
                                  Text(
                                    tr('document_upload_second_instruction'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              child: IconButton(
                                onPressed: _uploadedImages.length < 5
                                    ? getCamera
                                    : null,
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 25,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          children: List.generate(
                            _uploadedImages.length,
                            (index) => Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _uploadedImages[index] != null
                                        ? _uploadedImages[index]
                                            .path
                                            .split('/')
                                            .last
                                        : "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _uploadedImages.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: ElevatedButton(
                                  child: Text(
                                    tr('phone_verification_button')
                                        .toUpperCase(),
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      if (_uploadedImages.isNotEmpty) {
                                        setState(() {
                                          _loading = true;
                                        });
                                        widget.onUploadDoc(
                                            _docType,
                                            _docNumber,
                                            dateCtl.text,
                                            _uploadedImages,
                                            () => setState(() {
                                                  _loading = false;
                                                }));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "${tr('upload_document')}",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            webShowClose: true,
                                            webPosition: "center",
                                            webBgColor: toHex(Colors.red),
                                            fontSize: 16.0);
                                      }
                                    }
                                  },
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
}

class AccountScreenVerifyDocumentsConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountPageModel>(
      model: AccountPageModel(),
      onWillChange: (vm) {
        if (vm.error != null) {
          vm.clearError();
          SnackBarNotifier.createSnackBar(
              tr(vm.error.graphqlErrors.first.message) ??
                  'Something went wrong',
              context,
              Status.error);
        }
      },
      builder: (BuildContext context, AccountPageModel vm) =>
          AccountScreenVerifyDocuments(
              onUploadDoc: vm.onUploadDoc, user: vm.user),
    );
  }
}
