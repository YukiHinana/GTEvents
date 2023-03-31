
import 'dart:convert';

import 'package:GTEvents/component/eventCard.dart';
import 'package:GTEvents/component/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'event.dart';

//SavedEventsPage
class SavedEventsPage extends StatefulWidget {
  const SavedEventsPage({super.key});

  @override
  State<SavedEventsPage> createState() => _SavedEventsPage();
}
//SavedEventsPage interface
class _SavedEventsPage extends State<SavedEventsPage> {

  Future<List<Event>> _fetchSavedEvents(String? token) async {
    // print(token);
    var response = await http.get(
      Uri.parse('${Config.baseURL}/events/saved'),
      headers: {"Content-Type": "application/json", "Authorization": token??""},
    );
    // print(jsonDecode(response.body)['data'].length);
    List<Event> eventList = [];
    for (var i in jsonDecode(response.body)['data']) {
      Map<String, dynamic> map = Map<String, dynamic>.from(i);
      eventList.add(Event(map['id'], map['title'], map['location'],
          map['description'], map['capacity'], map['fee']));
    }
    // print(eventList);
    // print(eventList);

    return eventList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Events'),
        actions: <Widget>[
          IconButton(
              onPressed: () => context.go('/events'),
              icon: const Icon(Icons.home))
        ],
      ),
      // body: FutureBuilder<List<Event>>(
      //     future: _fetchSavedEvents(
      //         StoreProvider.of<AppState>(context).state.token),
      //     builder: (context, snapshot) {
      //       return ListView.builder(
      //         itemCount: snapshot.data?.length,
      //         itemBuilder: (context, index) {
      //           // print(snapshot.data??"");
      //           return Container();
      //           // return EventCard(eventId: snapshot.data,
      //           //     title: snapshot.data?[index]['title'],
      //           //     location: snapshot.data?[index]['location']);
      //         }
      //       );
      //     }
      // ),
      drawer: const UserSideBar(),
    );
  }
}