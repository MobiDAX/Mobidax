import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/redux.dart';

import 'history_page.dart';

class HistoryPageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HistoryPageModel>(
      model: HistoryPageModel(),
      onInit: (st) {
        if (st.state.accountUserState.userSession.barongSession != '') {
          st.dispatch(
            OrdersHistoryFetchAction(),
          );
          st.dispatch(
            FetchTradeHistoryAction(),
          );
        }
      },
      builder: (BuildContext context, HistoryPageModel vm) => HistoryPage(
        tradeHistory: vm.tradeHistory,
        orderHistory: vm.orderHistory,
      ),
    );
  }
}
