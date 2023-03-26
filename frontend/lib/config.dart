import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';

class Config {
  // static const baseURL = "http://3.145.83.83:8080";
  static const baseURL = "http://localhost:8080";
}

@immutable
class AppState {
  final String? token;

  const AppState({this.token});
}

final tokenReducer = combineReducers<String?>([
  TypedReducer<String?, SetTokenAction>((state, action) => action.token),
]);

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    token: tokenReducer(state.token, action),
  );
}

class SetTokenAction {
  final String? token;

  SetTokenAction(this.token);
}