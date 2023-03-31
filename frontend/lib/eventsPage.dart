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

  Future<http.Response> fetchEventsRequest() async {
    var response = await http.get(
      Uri.parse('${Config.baseURL}/events/events?pageNumber=$curScrollPage&pageSize=8'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  //Event page mapping post event to all the events
  Future<List<dynamic>> getEvents() async {
    List<dynamic> eventList = [];
    http.Response re = await fetchEventsRequest();
    Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(re.body)['data']);
    if (re.statusCode == 200) {
      eventList = map['content'];
    }
    return eventList;
  }

  List<EventCard> eventCardList = [];

  //Get events details from posting events
  Future<List<EventCard>> getEventCards(String? token) async {
    List<dynamic> eventList = await getEvents();
    List<Event> savedEventList = await fetchSavedEvents(token);
    // List<EventCard> eventCardList = [];
    for (var info in eventList) {
      var isSaved = false;
      for (Event e in savedEventList) {
        if (e.eventId == info['id']) {
          isSaved = true;
        }
      }
      eventCardList.add(EventCard(eventId: info['id'],title: info['title'], location: info['location'], isSaved: isSaved));
    }
    // setState(() {
    //   events = events + eventCardList;
    // });
    return eventCardList;
  }

  // Future<List<dynamic>> getSavedEvents(String? token) async {
  //
  //   await fetchSavedEvents(token);
  //   Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(response.body)['data']);
  //   if (response.statusCode == 200) {
  //     savedEventList = map['content'];
  //   }
  //   return savedEventList;
  // }

  //All Event array lists
  // List<EventCard> events = [];
  int curScrollPage = 0;

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent
        && !_scrollController.position.outOfRange) {
      setState(() {
        curScrollPage += 1;
        getEventCards(StoreProvider.of<AppState>(context).state.token);
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    // getEventCards(StoreProvider.of<AppState>(context).state.token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventCard>>(
      future: getEventCards(StoreProvider.of<AppState>(context).state.token),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
        controller: _scrollController,
            itemCount: snapshot.data?.length??0,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: snapshot.data?[index],
              );
            }
        );
      }
    );
  }
}