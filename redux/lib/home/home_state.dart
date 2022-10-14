import 'package:json_annotation/json_annotation.dart';

part 'home_state.g.dart';

@JsonSerializable(nullable: false)
class HomePageState {
  final bool homeVisited;

  HomePageState({this.homeVisited = false});

  HomePageState copy({bool homeVisited}) =>
      HomePageState(homeVisited: homeVisited ?? this.homeVisited);

  factory HomePageState.fromJson(Map<String, dynamic> json) =>
      _$HomePageStateFromJson(json);
  Map<String, dynamic> toJson() => _$HomePageStateToJson(this);

  static HomePageState initialState() => HomePageState(homeVisited: false);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomePageState &&
          runtimeType == other.runtimeType &&
          homeVisited == other.homeVisited;

  @override
  int get hashCode => homeVisited.hashCode;
}
