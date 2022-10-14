import 'package:easy_localization/easy_localization.dart';

import '../custom_navigation_drawer.dart';
import 'package:flutter/material.dart';

enum WebTabItem { exchange, funds, account, history }

Map<WebTabItem, String> webTabName = {
  WebTabItem.exchange: '/exchange',
  WebTabItem.funds: '/funds',
  WebTabItem.account: '/account',
  WebTabItem.history: '/history',
};

String namedWebTab(WebTabItem tab) {
  switch (tab) {
    case WebTabItem.exchange:
      return tr('exchange_label');
    case WebTabItem.funds:
      return tr('funds_label');
    case WebTabItem.account:
      return tr('account_label');
    case WebTabItem.history:
      return tr('history_label');
    default:
      return '';
  }
}

class CollapsingNavigationDrawer extends StatefulWidget {
  final WebTabItem currentTab;
  final ValueChanged<WebTabItem> onSelectTab;
  final String email;
  final Function onLogOut;
  final bool isAuthorized;

  CollapsingNavigationDrawer(
      {this.currentTab,
      this.onSelectTab,
      this.email,
      this.onLogOut,
      this.isAuthorized});

  @override
  CollapsingNavigationDrawerState createState() {
    return new CollapsingNavigationDrawerState();
  }
}

class CollapsingNavigationDrawerState extends State<CollapsingNavigationDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth = 210;
  double minWidth = 70;
  bool isCollapsed = true;
  bool isHovered = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  Animation<double> sizedBoxAnimation;
  Animation<double> widthAnimationForLogOut;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: minWidth, end: maxWidth)
        .animate(_animationController);
    widthAnimationForLogOut = Tween<double>(begin: 70, end: 200).animate(
      _animationController,
    );
    sizedBoxAnimation = Tween<double>(begin: 0, end: 10).animate(
      _animationController,
    );
  }

  @override
  Widget build(BuildContext context) {
    ValueChanged<WebTabItem> onSelectTab = widget.onSelectTab;
    String email = widget.email;
    Function onLogOut = widget.onLogOut;
    int selectedIndex = widget.currentTab.index;
    bool isAuthorized = widget.isAuthorized;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => getWidget(context, widget, onSelectTab,
          email, onLogOut, selectedIndex, isAuthorized),
    );
  }

  Widget getWidget(
      BuildContext context,
      widget,
      ValueChanged<WebTabItem> onSelectTab,
      String email,
      Function onLogOut,
      int selectedIndex,
      bool isAuthorized) {
    return Material(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
      elevation: 80.0,
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        width: widthAnimation.value,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0, top: 15),
              child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 4.0),
                  width: isCollapsed ? 70 : 180,
                  height: 25,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: isCollapsed
                        ? AssetImage('assets/icons/small_logo.png')
                        : AssetImage('assets/icons/logo.png'),
                  ))),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primaryVariant,
              height: 15.0,
              thickness: 2.0,
            ),
            Container(
              height: 230,
              // color: Colors.white.withOpacity(0.3),
              child: ListView.separated(
                separatorBuilder: (context, counter) {
                  return Divider(height: 12.0);
                },
                itemBuilder: (context, counter) {
                  return CollapsingListTile(
                    onTap: () {
                      if (counter < 4) {
                        onSelectTab(
                          WebTabItem.values[counter],
                        );
                      }
                    },
                    isSelected: selectedIndex == counter,
                    title: navigationItems[counter].title,
                    icon: navigationItems[counter].icon,
                    animationController: _animationController,
                  );
                },
                itemCount: navigationItems.length,
              ),
            ),
            Divider(height: 12.0),
            isAuthorized
                ? Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: InkWell(
                        onTap: () {
                          onLogOut();
                          onSelectTab(WebTabItem.values[0]);
                        },
                        onHover: (bool) {
                          setState(() {
                            isHovered = bool;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                16.0,
                              ),
                            ),
                            color: Colors.transparent,
                          ),
                          width: widthAnimationForLogOut.value,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.exit_to_app,
                                color: (isHovered)
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryVariant
                                    : Colors.white30,
                                size: 32.0,
                              ),
                              SizedBox(
                                width: sizedBoxAnimation.value,
                              ),
                              (widthAnimationForLogOut.value >= 190)
                                  ? Text(
                                      tr('log_out'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/signInPage');
                        },
                        onHover: (bool) {
                          setState(() {
                            isHovered = bool;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                16.0,
                              ),
                            ),
                            color: Colors.transparent,
                          ),
                          width: widthAnimationForLogOut.value,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.login,
                                color: (isHovered)
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryVariant
                                    : Colors.white30,
                                size: 32.0,
                              ),
                              SizedBox(
                                width: sizedBoxAnimation.value,
                              ),
                              (widthAnimationForLogOut.value >= 190)
                                  ? Text(
                                      tr('sign_in_label'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            InkWell(
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                  isCollapsed
                      ? _animationController.reverse()
                      : _animationController.forward();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_arrow,
                progress: _animationController,
                color: Theme.of(context).colorScheme.primaryVariant,
                size: 32.0,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
