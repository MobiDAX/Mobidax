import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobidax_redux/redux.dart';
import '../store.dart';

class HistoryPageModel extends BaseModel<AppState> {
  final List<TradeItem> tradeHistory;
  final List<OrderItem> orderHistory;

  HistoryPageModel({this.tradeHistory, this.orderHistory});

  VoidCallback onFetchBalance;
  Function(int id, String currency) onShowWallet;

  HistoryPageModel.build({this.tradeHistory, this.orderHistory})
      : super(equals: [
          tradeHistory,
          orderHistory,
        ]);

  @override
  HistoryPageModel fromStore() => HistoryPageModel.build(
        tradeHistory: state.accountUserState.tradeHistory,
        orderHistory: state.accountUserState.ordersHistory,
      );
}
