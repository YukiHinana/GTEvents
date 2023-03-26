import 'package:GTEvents/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, appState) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    child: Text('username???')
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
              ],
            ),
          );
        }
    );
  }
}