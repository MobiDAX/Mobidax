import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:mobidax_redux/redux.dart';
import 'home_widget.dart';

class HomePageConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageModel>(
      onInitialBuild: (vm) {
        if (vm.homeVisited || vm.isAuthorized) {
          Navigator.pushReplacementNamed(
            context,
            '/nav',
          );
        }
      },
      onWillChange: (vm) {
        if (vm.homeVisited || vm.isAuthorized) {
          Navigator.pushReplacementNamed(
            context,
            '/nav',
          );
        }
      },
      model: HomePageModel(),
      builder: (BuildContext context, HomePageModel vm) => HomePage(
        onGetStarted: vm.onGetStarted,
      ),
    );
  }
}
