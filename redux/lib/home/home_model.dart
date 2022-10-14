import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:mobidax_redux/markets/markets_actions.dart';
import 'home_actions.dart';
import '../store.dart';

class HomePageModel extends BaseModel<AppState> {
  final bool homeVisited;
  final bool isAuthorized;

  HomePageModel({this.homeVisited, this.isAuthorized});

  VoidCallback onGetStarted;

  HomePageModel.build(
      {@required this.onGetStarted, this.homeVisited, this.isAuthorized})
      : super(equals: [homeVisited, isAuthorized]);

  @override
  HomePageModel fromStore() => HomePageModel.build(
      onGetStarted: () {
        dispatchFuture(MarketsFetchAction());
        dispatch(HomeVisitedAction());
        dispatch(NavigateAction.pushReplacementNamed("/"));
      },
      homeVisited: state.homePageState.homeVisited,
      isAuthorized: state.accountUserState.isAuthourized);
}
