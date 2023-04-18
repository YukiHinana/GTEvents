import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';

//change URL to your local ip to run
class Config {
  static const baseURL = "http://3.145.83.83:8080";
  //static const baseURL = "http://localhost:8080";
}
//User infor entity
class UserInfo {
  final String? username;
  UserInfo(this.username);
}
//AppState entity
@immutable
class AppState {
  final String? token;
  final UserInfo? userInfo;

  const AppState({this.token, this.userInfo});
}

//Token Reducer
final tokenReducer = combineReducers<String?>([
  TypedReducer<String?, SetTokenAction>((state, action) => action.token),
]);
//User Info Reducer
final userInfoReducer = combineReducers<UserInfo?>([
  TypedReducer<UserInfo?, SetUsernameAction>((state, action) => UserInfo(action.username)),
]);


// app state reducer
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    token: tokenReducer(state.token, action),
    userInfo: userInfoReducer(state.userInfo, action),
  );
}
//SetTokenAction
class SetTokenAction {
  final String? token;
  SetTokenAction(this.token);
}
//SetUsernameAction
class SetUsernameAction {
  final String? username;
  SetUsernameAction(this.username);
}