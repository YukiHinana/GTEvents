
import 'dart:convert';

import 'package:GTEvents/config.dart';
import 'package:GTEvents/component/sidebar.dart';
import 'package:GTEvents/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'event.dart';
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
      if (tokenVal != null) {
        handleFindUsernameByTokenRequest(tokenVal).then((usernameVal) =>
            StoreProvider.of<AppState>(context).dispatch(SetUsernameAction(usernameVal)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GTEvents'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: StoreConnector<AppState, AppState>(
        converter: (store) {
          return store.state;
        },
        builder: (context, appState) {
          return const EventsPage();
        },
      ),
      drawer: const UserSideBar(),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = ['a', 'b', 'c', 'd'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // return <Widget>[];
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.navigate_before),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  Future<List<dynamic>> _searchEvents() async {
    var response = await http.get(
      Uri.parse('${Config.baseURL}/events/events/search?pageNumber=0&pageSize=15&keyword=$query'),
      headers: {"Content-Type": "application/json"},
    );
    List<dynamic> eventList = [];
    Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(response.body)['data']);
    if (response.statusCode == 200) {
      eventList = map['content'];
    }
    return eventList;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: _searchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => context.push("/events/${snapshot.data?[index]['id']}"),
                  title: Text(snapshot.data?[index]['title']),
                );
              },
              itemCount: snapshot.data?.length,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}

