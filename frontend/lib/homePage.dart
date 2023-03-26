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
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _prefs.then((value) {
      StoreProvider.of<AppState>(context)
          .dispatch(SetTokenAction(value.getString('token')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GTEvents'),
        actions: <Widget>[
          IconButton(
              onPressed: () => context.go('/events'),
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
              ElevatedButton(
                  onPressed: () {
                    StoreProvider.of<AppState>(context).dispatch(
                        SetTokenAction("1"));
                  },
                  child: Text('1')
              ),
              ElevatedButton(
                  onPressed: () {
                    StoreProvider.of<AppState>(context).dispatch(
                        SetTokenAction(null));
                  },
                  child: Text('0')
              ),
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
  String username = "unko";

  @override
  void initState() {
    super.initState();
    // handleFindAccountByTokenRequest().then((value) {
    //   setState(() {
    //     username = value;
    //   });
    // });
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

  Future<String> handleFindAccountByTokenRequest() async {
    var token = StoreProvider.of<AppState>(context).state.token;
    if (token != null) {
      var response = await http.get(
          Uri.parse('${Config.baseURL}/account/find'),
          headers: {"Content-Type": "application/json", "Authorization": token},
      );
      return jsonDecode(response.body)['data']['username'];
    }
    return "??";
  }

  Widget getUsername() {
    handleFindAccountByTokenRequest().then((value) {
      setState(() {
        username = value;
      });
    });
    return Text(username);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, appState) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    child: getUsername(),
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
                    handleFindAccountByTokenRequest();
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
                ListTile(
                  title: appState.token == null ? const Text('') : const Text('Logout'),
                  onTap: () {
                    if (appState.token != null) {
                      Future<http.Response> re = handleLogoutRequest();
                      re.then((value) {
                        if (value.statusCode == 200) {
                          StoreProvider.of<AppState>(context).dispatch(SetTokenAction(null));
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          );
        }
    );
  }
}