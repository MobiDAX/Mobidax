import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/funds/funds_state.dart';

import '../../components/wallet_history_item.dart';

class WithdrawalHistoryPage extends StatelessWidget {
  const WithdrawalHistoryPage({
    this.withdrawals,
    this.isLoading,
    this.onWithdrawHistory,
  });

  final bool isLoading;
  final List<WithdrawalItem> withdrawals;
  final Function onWithdrawHistory;

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
        title: Text(
          tr('withdrawal_history'),
          overflow: TextOverflow.ellipsis,
        ),
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
                          onWithdrawHistory();
                        },
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: withdrawals.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 5,
                          ),
                          itemBuilder: (context, i) {
                            var item = withdrawals[i];
                            return WalletHistoryItem(
                              status:
                                  '${item.state[0].toUpperCase()}${item.state.substring(1)}',
                              amount: item.amount,
                              timestamp: item.createdAt,
                              transactionId: item.blockchainTXID ?? '',
                              currency: item.currency.toUpperCase(),
                              fee: item.fee,
                              modalTitle: tr('withdraw_info'),
                              isWithdrawal: true,
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
