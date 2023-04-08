
import 'dart:async';
import 'dart:convert';

import 'package:GTEvents/component/eventMenu.dart';
import 'package:GTEvents/component/eventTile.dart';
import 'package:GTEvents/savedEventsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'component/eventCard.dart';
import 'config.dart';
import 'createEvent.dart';
import 'package:http/http.dart' as http;

import 'component/sidebar.dart';
import 'event.dart';

class CreatedEventsPage extends StatefulWidget {
  const CreatedEventsPage({super.key});

  @override
  State<CreatedEventsPage> createState() => _CreatedEventsPage();
}

class _CreatedEventsPage extends State<CreatedEventsPage> {
  Future<List<Event>> fetchCreatedEvents(String? token) async {
    List<Event> eventList = [];
    if (token == null) {
      return eventList;
    }
    var response = await http.get(
      Uri.parse('${Config.baseURL}/events/created'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token
      },
    );
    if (response.statusCode == 200) {
      for (var i in jsonDecode(utf8.decode(response.bodyBytes))['data']) {
        Map<String, dynamic> map = Map<String, dynamic>.from(i);
        List<Event> savedEventList = await fetchSavedEvents(token);
        var isSaved = false;
        for (Event e in savedEventList) {
          if (e.eventId == map['id']) {
            isSaved = true;
          }
        }
        eventList.add(Event(map['id'], map['title'], map['location'],
                  map['description'], map['eventDate']??0, map['capacity'],
                  map['fee'], isSaved, map['eventCreationDate']??0));
      }
    }
    return eventList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: add search bar for this page
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events Created'),
        actions: <Widget>[
          IconButton(
              onPressed: () => context.pushReplacement('/events'),
              icon: const Icon(Icons.home))
        ],
      ),
      body: FutureBuilder<List<Event>>(
          future: fetchCreatedEvents(
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
                      curItem.eventDateTimestamp, 0, 0, curItem.isSaved,
                      curItem.eventCreationTimestamp);
                  return Column(
                    children: [
                      const Divider(
                        indent: 1,
                        endIndent: 1,
                        thickness: 1,
                        color: Colors.black54,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "event created on ${
                                      DateFormat('MM/dd/yyyy, HH:mm').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              curItem.eventCreationTimestamp * 1000))
                                  }"
                              ),
                            ),
                            EventMenu(eventId: curItem.eventId,),
                          ],
                        )
                      ),
                      EventTile(event: e),
                    ],
                  );
                }
            );
          }
      ),
      drawer: const UserSideBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push("/events/create"),
        label: const Text("Create New Event"),
      ),
    );
  }
}