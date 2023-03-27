import 'dart:convert';

import 'package:GTEvents/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _prefs.then((value) {
      var result = value.getString('token');
      var tokenVal = result == "" || result == null ? null : result;
      StoreProvider.of<AppState>(context).dispatch(SetTokenAction(tokenVal));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GTEvents'),
        actions: <Widget>[
          IconButton(
              onPressed: () => context.go('/search'),
              icon: const Icon(Icons.search))
        ],
      ),
      body: StoreConnector<AppState, AppState>(
        converter: (store) {
          return store.state;
        },
        builder: (context, appState) {
          // TODO: test only, change this to events page
          return Column(
            children: [

            ],
          );
        },
      ),
      drawer: const UserSideBar(),
    );
  }
}

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
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  child: Text(appState.userInfo?.username??"unknown"),
                ),
                ListTile(
                  title: appState.token == null ? const Text('Login') : const Text('View Profile'),
                  onTap: () {
                    if (appState.token == null) {
                      context.push('/login');
                    }
                  },
                ),
                ListTile(
                  title: const Text('Created Events'),
                  onTap: () {
                    context.pop();
                    context.push('/events/created');
                  },
                ),
                ListTile(
                  title: const Text('Saved Events'),
                  onTap: () {
                    context.pop();
                    context.push('/events/saved');
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
                          StoreProvider.of<AppState>(context).dispatch(SetUsernameAction("unknown"));
                          final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
                          (await prefs).setString("token", "");
                        }
                      });
                    },
                  )
              ],
            ),
          );
        }
    );
  }
}