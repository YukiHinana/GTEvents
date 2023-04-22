import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class UserSideBar extends StatefulWidget {
  const UserSideBar({super.key});

  @override
  State<UserSideBar> createState() => _UserSideBar();
}

class _UserSideBar extends State<UserSideBar> {
  @override
  void initState() {
    super.initState();
  }

  Future<http.Response> handleLogoutRequest() async {
    var logoutRequest = json.encode(
        {
          'token': StoreProvider.of<AppState>(context).state.token,
        });
    var response = await http.post(
        Uri.parse('${Config.baseURL}/account/logout'),
        headers: {"Content-Type": "application/json"},
        body: logoutRequest
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, appState) {
          return Drawer(
            child: Container(
              color: const Color(0xffeaeecf),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color(0xffc5d790),
                    ),
                    child: Text(appState.userInfo?.username??""),
                  ),
                  ListTile(
                    title: appState.token == null ? const Text('Login') : const Text('View Profile'),
                    onTap: () {
                      if (appState.token == null) {
                        context.push('/login');
                      } else {
                        context.push("/user/profile");
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('Created Events'),
                    onTap: () {
                      context.pushReplacement('/events/created');
                    },
                  ),
                  ListTile(
                    title: const Text('Saved Events'),
                    onTap: () {
                      context.pushReplacement('/events/saved');
                    },
                  ),
                  if (StoreProvider.of<AppState>(context).state.token != null)
                    ListTile(
                      title: const Text('Logout'),
                      onTap: () {
                        Future<http.Response> re = handleLogoutRequest();
                        re.then((value) async {
                          if (value.statusCode == 200) {
                            StoreProvider.of<AppState>(context).dispatch(SetTokenAction(null));
                            StoreProvider.of<AppState>(context).dispatch(SetUsernameAction(null));
                            final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
                            (await prefs).setString("token", "");
                            // TODO: change this
                            context.pushReplacement("/events");
                          }
                        });
                      },
                    )
                ],
              ),
            ),
          );
        }
    );
  }
}