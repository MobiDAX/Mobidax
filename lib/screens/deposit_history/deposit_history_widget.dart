import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/funds/funds_state.dart';

import '../../components/wallet_history_item.dart';

class DepositHistoryPage extends StatelessWidget {
  const DepositHistoryPage({
    this.deposits,
    this.isLoading,
    this.onDepositHistory,
    this.explorerTransaction,
  });

  final bool isLoading;
  final List<DepositItem> deposits;
  final Function onDepositHistory;
  final String explorerTransaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(tr('deposit_history')),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor,
                  ),
                ),
              )
            : Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      child: RefreshIndicator(
                        color: Theme.of(context).accentColor,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        onRefresh: () async {
                          onDepositHistory();
                        },
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: deposits.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 5,
                          ),
                          itemBuilder: (context, i) {
                            var item = deposits[i];
                            return WalletHistoryItem(
                              status:
                                  "${item.state[0].toUpperCase()}${item.state.substring(1)}",
                              amount: item.amount,
                              timestamp: int.parse(item.createdAt),
                              transactionId: item.blockchainTXID ?? "",
                              currency: item.currency.toUpperCase(),
                              explorerTransaction: explorerTransaction,
                              fee: item.fee,
                              modalTitle: tr('deposit_info'),
                              isWithdrawal: false,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
