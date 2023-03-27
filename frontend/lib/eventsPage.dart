import 'dart:convert';
import 'package:GTEvents/component/eventCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPage();
}

class _EventsPage extends State<EventsPage> {
  Future<http.Response> getEventsRequest() async {
    var response = await http.get(
      Uri.parse('${Config.baseURL}/events/events?pageNumber=0&pageSize=2'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<List<dynamic>> getEvents() async {
    List<dynamic> eventList = [];
    http.Response re = await getEventsRequest();
    Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(re.body)['data']);
    if (re.statusCode == 200) {
      eventList = map['content'];
    }
    return eventList;
  }

  Future<List<EventCard>> getEventCards() async {
    List<dynamic> eventList = await getEvents();
    List<EventCard> eventCardList = [];

    for (var info in eventList) {
      eventCardList.add(EventCard(title: info['title'], location: info['location']));
    }
    return eventCardList;
  }

  List<EventCard> events = [];

  @override
  void initState() {
    super.initState();
    getEventCards().then((value) {
      setState(() {
        print(value);
        events = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: SizedBox(
        height: 200,
        width: 250,
        child: (Text('aa')),
      ),
    );
  }
}
