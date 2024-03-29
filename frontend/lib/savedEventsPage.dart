
import 'dart:convert';

import 'package:GTEvents/component/eventCard.dart';
import 'package:GTEvents/component/eventTile.dart';
import 'package:GTEvents/component/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'event.dart';

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
      "Authorization": token
    },
  );
  if (response.statusCode == 200) {
    for (var i in jsonDecode(utf8.decode(response.bodyBytes))['data']) {
      Map<String, dynamic> map = Map<String, dynamic>.from(i);
      eventList.add(Event(map['id'], map['title'], map['location'],
          map['description'], map['eventDate']??0, map['capacity'],
          map['fee'], true,
          map['eventCreationDate']??0, map['author']['username']));
    }
  }
  return eventList;
}

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
                  Event e = Event(curItem.eventId, curItem.title,
                      curItem.location, curItem.description,
                      curItem.eventDateTimestamp, 0, 0, true,
                      curItem.eventCreationTimestamp, curItem.organizer);
                  return EventTile(event: e);
                }
            );
          }
      ),
      drawer: const UserSideBar(),
    );
  }
}