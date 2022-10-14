import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobidax_redux/account/account_actions.dart';
import 'package:mobidax_redux/account/account_state.dart';
import '../helpers.dart';
import '../store.dart';
import '../graphql_client.dart';

class CreateBeneficiaryAction extends ReduxAction<AppState> {
  final String currency;
  final String address;
  final String name;
  final String description;

  CreateBeneficiaryAction({
    this.currency,
    this.address,
    this.name,
    this.description,
  });

  static const CreateBeneficiaryMutation = r'''
         mutation ($_barong_session: String!, $currency: String!, $address: String!, $name: String!, $description: String) {
            addBeneficiaryCoin(_barong_session: $_barong_session, currency: $currency, address: $address,name: $name,description: $description){
               id
               name
               currency
               address
               description
               state
            }
         }
        ''';

  @override
  void before() {
    // TODO: implement after
    dispatch(BeneficiaryLoadingAction(loading: true));
    super.before();
  }

  @override
  Future<AppState> reduce() async {
    var barongSession = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(CreateBeneficiaryMutation),
      variables: <String, dynamic>{
        '_barong_session': barongSession,
        'currency': currency,
        'address': address,
        'name': name,
        'description': description,
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);
    if (result.hasException) {
      Fluttertoast.showToast(
          msg: tr('${result.exception.graphqlErrors[0].message}'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: 'center',
          webBgColor: toHex(Colors.red),
          fontSize: 16.0);
      return state.copy(
          createBeneficiaryPageState:
              state.createBeneficiaryPageState.copy(loading: false));
    } else {
      Fluttertoast.showToast(
          msg:
              "$name ${tr('beneficiary_add_success')} ${state.accountUserState.user.email}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: 'center',
          webBgColor: toHex(Colors.green),
          fontSize: 16.0);

      dispatch(NavigateAction.pushNamed('/confirmBeneficiary'));
      dispatch(GetBeneficiaries());
      return state.copy(
          createBeneficiaryPageState:
              state.createBeneficiaryPageState.copy(loading: false),
          confirmBeneficiaryPageState: state.confirmBeneficiaryPageState.copy(
              createdBeneficiary:
                  Beneficiary.fromJson(result.data['addBeneficiaryCoin'])));
    }
  }
}

class BeneficiaryLoadingAction extends ReduxAction<AppState> {
  final bool loading;

  BeneficiaryLoadingAction({this.loading});

  @override
  AppState reduce() {
    return state.copy(
        createBeneficiaryPageState:
            state.createBeneficiaryPageState.copy(loading: loading));
  }
}

class ClearBeneficiaryErrorAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return state.copy(
        createBeneficiaryPageState:
            state.createBeneficiaryPageState.copy(error: null));
  }
}

class CreateFiatBeneficiaryAction extends ReduxAction<AppState> {
  final String currency;
  final String fullName;
  final String name;
  final String accountNumber;
  final String bankName;

  CreateFiatBeneficiaryAction(
      {this.currency,
      this.fullName,
      this.name,
      this.accountNumber,
      this.bankName});

  static const CreateFiatBeneficiaryMutation = r'''
         mutation ($_barong_session: String!, $currency: String!, $full_name: String!, $name: String!, $account_number: String, $bank_name: String) {
            addBeneficiaryFiat(_barong_session: $_barong_session, currency: $currency, full_name: $full_name, name: $name, account_number: $account_number, bank_name: $bank_name){
               id
               name
               currency
               address
               description
               state
            }
         }
        ''';

  @override
  void before() {
    // TODO: implement after
    dispatch(BeneficiaryLoadingAction(loading: true));
    super.before();
  }

  @override
  Future<AppState> reduce() async {
    var barongSession = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(CreateFiatBeneficiaryMutation),
      variables: <String, dynamic>{
        '_barong_session': barongSession,
        'currency': currency,
        'full_name': fullName,
        'name': name,
        'account_number': accountNumber,
        'bank_name': bankName
      },
    );

    final QueryResult result = await GraphQLClientAPI.client().query(options);
    if (result.hasException) {
      Fluttertoast.showToast(
          msg: tr('${result.exception.graphqlErrors[0].message}'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: 'center',
          webBgColor: toHex(Colors.red),
          fontSize: 16.0);
      return state.copy(
          createBeneficiaryPageState:
              state.createBeneficiaryPageState.copy(loading: false));
    } else {
      List<Beneficiary> benef = List.from(state.accountUserState.beneficiaries);
      benef.add(Beneficiary.fromJson(result.data['addBeneficiaryFiat']));
      dispatch(NavigateAction.pushNamed('/confirmBeneficiary'));
      return state.copy(
          createBeneficiaryPageState:
              state.createBeneficiaryPageState.copy(loading: false),
          confirmBeneficiaryPageState: state.confirmBeneficiaryPageState.copy(
              createdBeneficiary:
                  Beneficiary.fromJson(result.data['addBeneficiaryFiat'])));
    }
  }
}

class DeleteBeneficiary extends ReduxAction<AppState> {
  final int id;

  DeleteBeneficiary({this.id});

  static const deleteBeneficiaryMutation = r'''
          mutation deleteBeneficiary(
           $_barong_session: String!,
           $id: Int!,
         
          ) {
            deleteBeneficiary(
            _barong_session: $_barong_session,
            id: $id,
           
          ){
              data
            }
          }
      ''';
  @override
  void after() {
    super.after();
  }

  @override
  Future<AppState> reduce() async {
    var session = state.accountUserState.userSession.barongSession;
    final QueryOptions options = QueryOptions(
      documentNode: gql(deleteBeneficiaryMutation),
      variables: <String, dynamic>{
        '_barong_session': session,
        'id': id,
      },
    );
    final QueryResult result = await GraphQLClientAPI.client().query(options);
    List<Beneficiary> res = List.from(state.accountUserState.beneficiaries);

    if (result.data['deleteBeneficiary']['data'] == 'ok') {
      res.removeWhere((element) => element.id == id);

      Fluttertoast.showToast(
          msg: "${tr('toast.delete.beneficiary')}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: "center",
          webBgColor: toHex(Colors.green),
          fontSize: 16.0);
    }

    return state.copy(
        accountUserState: state.accountUserState.copy(beneficiaries: res));
  }
}
