import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../components/spacers.dart';

class ModalHeader extends StatelessWidget {
  const ModalHeader({
    this.title,
    this.onIconPressed,
  });

  final String title;
  final Function onIconPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SpaceW16(),
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            onIconPressed ?? Navigator.of(context).pop();
          },
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              this.title,
              style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ),
        SpaceW40(),
      ],
    );
  }
}
