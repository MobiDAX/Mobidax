import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Uses 0.10 of Screen Height
class TabBarComp extends StatefulWidget {
  const TabBarComp({
    this.tabNames,
    this.selectedTabIndex,
    this.onTabSelect,
  });

  final List<String> tabNames;
  final int selectedTabIndex;
  final Function onTabSelect;

  @override
  _TabBarCompState createState() => _TabBarCompState();
}

class _TabBarCompState extends State<TabBarComp> {
  int selectedTabIndex;

  @override
  void initState() {
    selectedTabIndex = widget.selectedTabIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        children: List.generate(
          widget.tabNames.length,
          (index) => Expanded(
            child: RawMaterialButton(
              fillColor: selectedTabIndex == index
                  ? Theme.of(context).colorScheme.primary.withOpacity(
                        0.7,
                      )
                  : Theme.of(context).colorScheme.primary,
              shape: Border(
                bottom: BorderSide(
                  color: selectedTabIndex == index
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primaryVariant,
                  width: 2,
                ),
              ),
              child: Container(
                child: Text(
                  widget.tabNames[index],
                  overflow: TextOverflow.ellipsis,
                  style: selectedTabIndex == index
                      ? Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600)
                      : Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context).colorScheme.primaryVariant,
                          ),
                ),
              ),
              onPressed: () {
                _handlePressTab(index);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handlePressTab(int index) async {
    setState(() => selectedTabIndex = index);
    if (widget.onTabSelect != null) {
      widget.onTabSelect(index);
    }
  }
}
