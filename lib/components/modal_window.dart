import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModalWindow extends StatelessWidget {
  const ModalWindow({
    this.content,
    this.titleName,
  });

  final Widget content;
  final String titleName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
      ),
      titlePadding: const EdgeInsets.all(
        0.0,
      ),
      scrollable: true,
      title: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left: 12.0,
              ),
              child: Text(
                titleName,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                overflow: TextOverflow.fade,
              ),
            ),
            IconButton(
              splashColor: Colors.transparent,
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).colorScheme.onBackground,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: content,
    );
  }
}
