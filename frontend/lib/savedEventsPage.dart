
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

Future<List<Event>> fetchSavedEvents(String? token) async {
  List<Event> eventList = [];
  if (token == null) {
    return eventList;
  }
  var response = await http.get(
    Uri.parse('${Config.baseURL}/events/saved'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": token ?? ""
    },
  );
  for (var i in jsonDecode(response.body)['data']) {
    Map<String, dynamic> map = Map<String, dynamic>.from(i);
    eventList.add(Event(map['id'], map['title'], map['location'],
        map['description'], map['capacity'], map['fee']));
  }
  return eventList;
}

//SavedEventsPage interface
class _SavedEventsPage extends State<SavedEventsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Events'),
        actions: <Widget>[
          IconButton(
              onPressed: () => context.pushReplacement('/events'),
              icon: const Icon(Icons.home))
        ],
      ),
      body: FutureBuilder<List<Event>>(
          future: fetchSavedEvents(
              StoreProvider.of<AppState>(context).state.token),
          builder: (context, snapshot) {
            print(snapshot.data);
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data?.length??0,
                itemBuilder: (context, index) {
                  var curItem = snapshot.data![index];
                  return EventCard(eventId: curItem.eventId,
                      title: curItem.title,
                      location: curItem.location,
                      isSaved: true
                  );
                }
            );
          }
      ),
      drawer: const UserSideBar(),
    );
  }
}