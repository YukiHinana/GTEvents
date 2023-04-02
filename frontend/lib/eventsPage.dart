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

<<<<<<< Updated upstream
  Future<http.Response> fetchEventsRequest() async {
=======
  Future<http.Response> fetchEventsRequest(int page) async {
>>>>>>> Stashed changes
    var response = await http.get(
      Uri.parse(
          '${Config.baseURL}/events/events?pageNumber=$page&pageSize=8'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  //Event page mapping post event to all the events
  Future<List<dynamic>> getEvents(int page) async {
    List<dynamic> eventList = [];
    http.Response re = await fetchEventsRequest(page);
    Map<String, dynamic> map =
        Map<String, dynamic>.from(jsonDecode(re.body)['data']);
    if (re.statusCode == 200) {
      eventList = map['content'];
<<<<<<< Updated upstream
=======
      if (page == 0) {
        limitedPages = map['totalPages'];
      }
>>>>>>> Stashed changes
    }
    return eventList;
  }

  List<EventCard> eventCardList = [];
  
  //Get events details from posting events
<<<<<<< Updated upstream
  Future<List<EventCard>> getEventCards(String? token) async {
    List<dynamic> eventList = await getEvents();
    List<Event> savedEventList = await fetchSavedEvents(token);
    // List<EventCard> eventCardList = [];
=======
  Future<List<EventCard>> getEventCards(String? token, {int page = 0}) async {
    // List<Event> newEventList = [...events];
    List<EventCard> newCards = [...eventCardList]; // Cloning eventCardList
    List<dynamic> eventList = await getEvents(page);
    List<Event> savedEventList = await fetchSavedEvents(token);
    // int cardlen = 0;
>>>>>>> Stashed changes
    for (var info in eventList) {
      var isSaved = false;
      for (Event e in savedEventList) {
        if (e.eventId == info['id']) {
          isSaved = true;
        }
      }
<<<<<<< Updated upstream
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
=======
      // cardlen += 1;
      newCards.add(EventCard(
          eventId: info['id'],
          title: info['title'],
          location: info['location'],
          isSaved: isSaved));
    }
    return newCards;
  }

>>>>>>> Stashed changes
  int curScrollPage = 0;
  bool isLoading = false;

  _scrollListener() {
<<<<<<< Updated upstream
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent
        && !_scrollController.position.outOfRange) {
      setState(() {
        curScrollPage += 1;
        getEventCards(StoreProvider.of<AppState>(context).state.token);
=======
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        isLoading = true;
      });
      getEventCards(StoreProvider.of<AppState>(context).state.token, page: curScrollPage + 1).then((cards) {
        setState(() {
          curScrollPage = curScrollPage + 1;
          eventCardList = cards;
          isLoading = false;
        });
>>>>>>> Stashed changes
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    Future.delayed(Duration.zero, () async {
      var newCards = await getEventCards(StoreProvider.of<AppState>(context).state.token);
      setState(() {
        eventCardList = newCards;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
<<<<<<< Updated upstream
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
=======
        itemCount: isLoading ? eventCardList.length + 1 : eventCardList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < eventCardList.length) {
            return Container(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: eventCardList[index],
            );
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }

        });
>>>>>>> Stashed changes
  }
}
