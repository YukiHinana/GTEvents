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
  late ScrollController _scrollController;

  Future<http.Response> fetchEventsRequest() async {
    print('${Config.baseURL}/events/events?pageNumber=$curScrollPage&pageSize=8');
    var response = await http.get(
      Uri.parse('${Config.baseURL}/events/events?pageNumber=$curScrollPage&pageSize=8'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<List<dynamic>> getEvents() async {
    List<dynamic> eventList = [];
    http.Response re = await fetchEventsRequest();
    Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(re.body)['data']);
    if (re.statusCode == 200) {
      eventList = map['content'];
    }
    return eventList;
  }

  Future<void> getEventCards() async {
    List<dynamic> eventList = await getEvents();
    List<EventCard> eventCardList = [];
    for (var info in eventList) {
      eventCardList.add(EventCard(eventId: info['id'],title: info['title'], location: info['location']));
    }
    setState(() {
      events = events + eventCardList;
    });
  }

  List<EventCard> events = [];
  int curScrollPage = 0;

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent
        && !_scrollController.position.outOfRange) {
      setState(() {
        curScrollPage += 1;
        getEventCards();
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    getEventCards();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    controller: _scrollController,
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          return events[index];
        }
    );
  }
}