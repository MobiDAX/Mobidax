import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utils/theme.dart';

typedef OnToggle = void Function(bool selected);

// ignore: must_be_immutable
class CustomSwitch extends StatefulWidget {
  CustomSwitch({
    Key key,
    this.bgColor,
    this.selectedColor,
    @required this.selectedText,
    @required this.defaultText,
    this.onToggle,
    @required this.selected,
  }) : super(key: key);

  final String selectedText;
  final String defaultText;
  final Color bgColor;
  final Color selectedColor;
  final OnToggle onToggle;
  bool selected;

  static Widget switchButton(BuildContext context, String text, bool selected,
          VoidCallback onToggle,
          [Color bgColor, Color selectedColor]) =>
      exchangeTopButtonTheme(
        context,
        MaterialButton(
          elevation: 0,
          color: selected
              ? selectedColor ?? Theme.of(context).colorScheme.primaryVariant
              : bgColor ?? Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            side: selected
                ? BorderSide(
                    color: selectedColor ??
                        Theme.of(context).colorScheme.primaryVariant,
                  )
                : const BorderSide(
                    color: Colors.transparent,
                  ),
          ),
          child: Text(
            text,
            style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            textScaleFactor: 1,
          ),
          onPressed: () {
            onToggle();
          },
        ),
      );

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 4.0,
            ),
            child: CustomSwitch.switchButton(
              context,
              widget.defaultText,
              !widget.selected,
              _handleOnTap,
              widget.bgColor ?? widget.bgColor,
              widget.selectedColor ?? widget.selectedColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 4.0,
            ),
            child: CustomSwitch.switchButton(
              context,
              widget.selectedText,
              widget.selected,
              _handleOnTap,
              widget.bgColor ?? widget.bgColor,
              widget.selectedColor ?? widget.selectedColor,
            ),
          )
        ],
      ),
    );
  }

  void _handleOnTap() {
    setState(() => widget.selected = !widget.selected);
    if (widget.onToggle != null) {
      widget.onToggle(widget.selected);
    }
  }
}
