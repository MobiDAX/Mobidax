import 'package:simple_gravatar/simple_gravatar.dart';

import 'package:flutter/material.dart';

class CollapsingListTile extends StatefulWidget {
  const CollapsingListTile({
    @required this.title,
    @required this.icon,
    @required this.animationController,
    this.isSelected = false,
    this.email,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final String email;
  final AnimationController animationController;
  final bool isSelected;
  final Function() onTap;

  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {
  Animation<double> widthAnimation, sizedBoxAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    widthAnimation = Tween<double>(begin: 70, end: 200).animate(
      widget.animationController,
    );
    sizedBoxAnimation = Tween<double>(begin: 0, end: 10).animate(
      widget.animationController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (bool) {
        setState(() {
          isHovered = bool;
        });
      },
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              16.0,
            ),
          ),
          color: widget.isSelected
              ? Colors.transparent.withOpacity(
                  0.3,
                )
              : Colors.transparent,
        ),
        width: widthAnimation.value,
        margin: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 8.0,
        ),
        child: Row(
          children: <Widget>[
            widget.email != null &&
                    widget.email.isNotEmpty &&
                    (widget.icon == Icons.person)
                ? CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    maxRadius: 18.0,
                    backgroundImage: NetworkImage(
                      Gravatar(widget.email).imageUrl(
                        size: 1024,
                        fileExtension: true,
                        defaultImage: GravatarImage.robohash,
                      ),
                    ),
                  )
                : Icon(
                    widget.icon,
                    color: (widget.isSelected || isHovered)
                        ? Theme.of(context).colorScheme.primaryVariant
                        : Colors.white30,
                    size: 32.0,
                  ),
            SizedBox(
              width: sizedBoxAnimation.value,
            ),
            (widthAnimation.value >= 190)
                ? Text(
                    widget.title,
                    style: widget.isSelected
                        ? Theme.of(context).textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.w600,
                            )
                        : Theme.of(context).textTheme.bodyText1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
