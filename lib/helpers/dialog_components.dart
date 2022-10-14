import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogComponent extends StatelessWidget {
  const DialogComponent({
    this.title,
    this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title'.toUpperCase(),
          style: Theme.of(context).textTheme.overline.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        Text(
          '$value',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    this.dict,
  });

  final Map<String, String> dict;

  @override
  Widget build(BuildContext context) {
    List<DialogComponent> dialog = [];
    dict.forEach(
      (key, value) {
        if (value != null && value != null ? value.isNotEmpty : false)
          dialog.add(
            DialogComponent(
              title: key,
              value: value,
            ),
          );
      },
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: dialog,
    );
  }
}
