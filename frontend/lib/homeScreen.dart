import 'dart:convert';

import 'package:GTEvents/config.dart';
import 'package:GTEvents/event.dart';
import 'package:GTEvents/component/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'eventsPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          return EventsPage();
        },
      ),
      drawer: const UserSideBar(),
    );
  }
}


