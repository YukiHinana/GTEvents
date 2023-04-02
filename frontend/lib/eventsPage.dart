import 'dart:convert';
import 'package:GTEvents/component/eventCard.dart';
import 'package:GTEvents/savedEventsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPage();
}

//Event Page
class _EventsPage extends State<EventsPage> {
  late ScrollController _scrollController;

  Future<http.Response> fetchEventsRequest(int page) async {
    var response = await http.get(
      Uri.parse(
          '${Config.baseURL}/events/events?pageNumber=$page&pageSize=8'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  int limitedPages = 0;

  //Event page mapping post event to all the events
  Future<List<dynamic>> getEvents(int page) async {
    List<dynamic> eventList = [];
    http.Response re = await fetchEventsRequest(page);
    Map<String, dynamic> map =
    Map<String, dynamic>.from(jsonDecode(re.body)['data']);
    if (re.statusCode == 200) {
      eventList = map['content'];
      if (page == 0) {
        limitedPages = map['totalPages'];
      }
    }
    return eventList;
  }

  List<Event> eventList = [];

  //Get events details from posting events
  Future<List<Event>> fetchEvents(String? token, {int page = 0}) async {
    List<Event> newEventList = [...eventList]; // Cloning eventList
    List<dynamic> events = await getEvents(page);
    List<Event> savedEventList = await fetchSavedEvents(token);
    for (var info in events) {
      var isSaved = false;
      for (Event e in savedEventList) {
        if (e.eventId == info['id']) {
          isSaved = true;
        }
      }
      newEventList.add(
          Event(
              info['id'],
              info['title'],
              info['location'],
              info['description'],
              info['capacity'],
              info['fee'],
              isSaved)
      );
    }
    return newEventList;
  }

  int curScrollPage = 0;
  bool isLoading = false;

  _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (curScrollPage < limitedPages) {
        setState(() {
          isLoading = true;
        });
        fetchEvents(StoreProvider
            .of<AppState>(context)
            .state
            .token, page: curScrollPage + 1).then((events) {
          setState(() {
            curScrollPage = curScrollPage + 1;
            eventList = events;
            isLoading = false;
          });
        });
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    Future.delayed(Duration.zero, () async {
      var newEventList = await fetchEvents(StoreProvider
          .of<AppState>(context)
          .state
          .token);
      setState(() {
        eventList = newEventList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: isLoading ? eventList.length + 1 : eventList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < eventList.length) {
            return Container(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: EventCard(event: eventList[index],),
              // child: EventCard()eventList[index],

            );
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }
}
