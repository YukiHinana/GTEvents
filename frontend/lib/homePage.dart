import 'package:GTEvents/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
      appBar: AppBar(title: Text('GTEvents')),
      body: Column(
        children: [
          StoreConnector<AppState, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(SetTokenAction("1"));
              },
            builder: (context, callback) {
                return ElevatedButton(onPressed: callback, child: Text('1'));
            },
          ),
          // Text(StoreProvider.of<AppState>(context).state.token??""),
          StoreConnector<AppState, String>(
              converter: (store) => store.state.token??"null",
              builder: (context, token) => Text(token))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Text('username???')
            ),
            ListTile(
              title: Text('aa'),
              onTap: () async {
                final SharedPreferences prefs = await _prefs;
                if (prefs.getString('token') != null) {

                }
              },
            ),
            ListTile(
              title: Text('Created Events'),
            ),
            ListTile(
              title: Text('Saved Events'),
            ),
          ],
        ),
      ),
    );
  }
}