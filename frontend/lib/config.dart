import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';

//change URL to your local ip to run
class Config {
  static const baseURL = "http://3.145.83.83:8080";
  // static const baseURL = "http://localhost:8080";
}

class UserInfo {
  final String? username;
  UserInfo(this.username);
}

class FilterData {
  List<int> eventTypeTagSelectState;
  List<int> degreeTagSelectState;
  DateTime? startDate;
  DateTime? endDate;
  FilterData(this.eventTypeTagSelectState, this.degreeTagSelectState,
      this.startDate, this.endDate);
}

@immutable
class AppState {
  final String? token;
  final UserInfo? userInfo;
  final FilterData filterData;

  const AppState({this.token, this.userInfo, required this.filterData});
}

final tokenReducer = combineReducers<String?>([
  TypedReducer<String?, SetTokenAction>((state, action) => action.token),
]);

final userInfoReducer = combineReducers<UserInfo?>([
  TypedReducer<UserInfo?, SetUsernameAction>((state, action) => UserInfo(action.username)),
]);

final filterReducer = combineReducers<FilterData>([
  TypedReducer<FilterData, SetTagSelectStateAction>(
          (state, action) => FilterData(
              action.eventTypeTagSelectState,
              action.degreeTagSelectState, state.startDate, state.endDate)),
  TypedReducer<FilterData, SetFilterDateRangeAction>(
          (state, action) => FilterData(
          state.eventTypeTagSelectState,
          state.degreeTagSelectState, action.startDate, action.endDate)),
]);


AppState appReducer(AppState state, dynamic action) {
  return AppState(
    token: tokenReducer(state.token, action),
    userInfo: userInfoReducer(state.userInfo, action),
    filterData: filterReducer(state.filterData, action),
  );
}

class SetTagSelectStateAction {
  List<int> eventTypeTagSelectState;
  List<int> degreeTagSelectState;
  SetTagSelectStateAction(this.eventTypeTagSelectState, this.degreeTagSelectState);
}

class SetFilterDateRangeAction {
  DateTime? startDate;
  DateTime? endDate;
  SetFilterDateRangeAction(this.startDate, this.endDate);
}

class SetTokenAction {
  final String? token;
  SetTokenAction(this.token);
}

class SetUsernameAction {
  final String? username;
  SetUsernameAction(this.username);
}