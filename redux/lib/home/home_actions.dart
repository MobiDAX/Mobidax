import 'package:async_redux/async_redux.dart';
import '../store.dart';

class HomeVisitedAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return state.copy(
        homePageState: state.homePageState.copy(homeVisited: true));
  }
}
