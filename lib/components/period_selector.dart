import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobidax_redux/types.dart';

import '../utils/theme.dart';
import 'modal_window.dart';

class PeriodSelector extends StatefulWidget {
  const PeriodSelector({
    this.onPeriodSelect,
    this.selectedMarketName,
    this.textStyle,
    this.selectedPeriod,
  });

  final Function(int period, String selectedMarketName) onPeriodSelect;
  final String selectedMarketName;
  final int selectedPeriod;
  final TextStyle textStyle;

  @override
  _PeriodSelectorState createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  int _period;

  @override
  void initState() {
    _period = widget.selectedPeriod;
    super.initState();
  }

  void _handlePeriodChange(int value) {
    setState(() => _period = value);
    if (widget.onPeriodSelect != null) {
      widget.onPeriodSelect(
        value,
        widget.selectedMarketName,
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return exchangeTopButtonTheme(
      context,
      MaterialButton(
        color: Theme.of(context).colorScheme.primaryVariant,
        elevation: 8,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ModalWindow(
              titleName: 'Select Period',
              content: Column(
                children: periods.entries
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          _handlePeriodChange(e.value);
                        },
                        child: Row(
                          children: <Widget>[
                            Radio(
                              activeColor:
                                  Theme.of(context).colorScheme.primaryVariant,
                              focusColor:
                                  Theme.of(context).colorScheme.primaryVariant,
                              value: e.value,
                              groupValue: _period,
                              onChanged: _handlePeriodChange,
                            ),
                            Text(
                              e.key,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
        child: Text(
          periods.keys
              .firstWhere((k) => periods[k] == _period, orElse: () => '1m'),
          style:
              widget.textStyle ?? Theme.of(context).primaryTextTheme.bodyText2,
        ),
      ),
    );
  }
}
