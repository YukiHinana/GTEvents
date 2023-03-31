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
  int limitedPages = 0;

  Future<http.Response> fetchEventsRequest() async {
    print('${Config.baseURL}/events/events?pageNumber=$curScrollPage&pageSize=8');
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
      print("eventlistlen: ${eventList.length}");
      if (curScrollPage == 0) {
        limitedPages = map['totalPages'];
        print(limitedPages);
        print(map['totalElements']);
      }
    }
    return eventList;
  }

  List<EventCard> eventCardList = [];

  //Get events details from posting events
  Future<List<EventCard>> getEventCards(String? token) async {
    print("curpage: ${curScrollPage}");
    List<dynamic> eventList = await getEvents();
    print("eventlistlen, geteventcardfunc: ${eventList.length}");
    List<Event> savedEventList = await fetchSavedEvents(token);
    // List<EventCard> eventCardList = [];
    int cardlen = 0;
    for (var info in eventList) {
      var isSaved = false;
      for (Event e in savedEventList) {
        if (e.eventId == info['id']) {
          isSaved = true;
          break;
        }
      }
      cardlen += 1;
      eventCardList.add(EventCard(eventId: info['id'],title: info['title'], location: info['location'], isSaved: isSaved));
    }
    print("cardvarlen:${cardlen}");
    print("eventcardlen: ${eventCardList.length}");
    return eventCardList;
  }

  //All Event array lists
  // List<EventCard> events = [];
  int curScrollPage = 0;

  _scrollListener() {
    // print(_scrollController.offset);
    // print(_scrollController.position.maxScrollExtent);
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent
        && !_scrollController.position.outOfRange) {
      print(_scrollController.keepScrollOffset);
      setState(() {
        // print(limitedPages);
        // if (curScrollPage < limitedPages) {
        print("end");
          curScrollPage += 1;
          // getEventCards(StoreProvider.of<AppState>(context).state.token);
        // }
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
          print(snapshot.data?.length);
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