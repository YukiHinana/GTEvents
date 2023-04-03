import 'dart:convert';
import 'package:GTEvents/component/eventCard.dart';
import 'package:GTEvents/savedEventsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'config.dart';
import 'event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPage();
}

//Event Page
class _EventsPage extends State<EventsPage> {
  // late ScrollController _scrollController;

  // Future<http.Response> fetchEventsRequest(int page) async {
  //   var response = await http.get(
  //     Uri.parse(
  //         '${Config.baseURL}/events/events?pageNumber=$page&pageSize=8'),
  //     headers: {"Content-Type": "application/json"},
  //   );
  //   return response;
  // }

  // Future<List<dynamic>> getEvents(int page) async {
  //   List<dynamic> eventList = [];
  //   http.Response re = await fetchEventsRequest(page);
  //   Map<String, dynamic> map =
  //   Map<String, dynamic>.from(jsonDecode(re.body)['data']);
  //   if (re.statusCode == 200) {
  //     eventList = map['content'];
  //     if (page == 0) {
  //       limitedPages = map['totalPages'];
  //     }
  //   }
  //   return eventList;
  // }

  List<Event> eventList = [];
  late int limitedPages;
  int curScrollPage = 0;
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<bool> fetchEvents(String? token, {bool isRefresh = false}) async {
    print("page: $curScrollPage");
    if (isRefresh) {
      curScrollPage = 0;
      print("refresh $curScrollPage");
    } else {
      if (curScrollPage > limitedPages) {
        refreshController.loadNoData();
        return false;
      }
    }
    List<Event> newEventList = [];
    print('${Config.baseURL}/events/events?pageNumber=${curScrollPage}&pageSize=8');
    var response = await http.get(
      Uri.parse(
          '${Config.baseURL}/events/events?pageNumber=${curScrollPage}&pageSize=8'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = Map<String, dynamic>.from(
          jsonDecode(response.body)['data']);
      List<dynamic> fetchResult = map['content'];
      // if (curScrollPage == 1) {
        limitedPages = map['totalPages'];
      // }
      List<Event> savedEventList = await fetchSavedEvents(token);
      print("token $token");
      for (var info in fetchResult) {
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
                isSaved
            )
        );
      }
      if (isRefresh) {
        eventList = [...newEventList];
        print("refresh: $eventList");
      } else {
        eventList.addAll(newEventList);
        print("loading: $eventList");
      }
      curScrollPage++;
      setState(() {});
      return true;
    }
    return false;
  }

  // Future<List<Event>> fetchEvents(String? token, {int page = 0}) async {
  //   List<Event> newEventList = [...eventList]; // Cloning eventList
  //   List<dynamic> events = await getEvents(page);
  //   List<Event> savedEventList = await fetchSavedEvents(token);
  //   for (var info in events) {
  //     var isSaved = false;
  //     for (Event e in savedEventList) {
  //       if (e.eventId == info['id']) {
  //         isSaved = true;
  //       }
  //     }
  //     newEventList.add(
  //         Event(
  //             info['id'],
  //             info['title'],
  //             info['location'],
  //             info['description'],
  //             info['capacity'],
  //             info['fee'],
  //             isSaved
  //         )
  //     );
  //   }
  //   return newEventList;
  // }

  // bool isLoading = false;
  // _scrollListener() {
  //   if (_scrollController.offset >=
  //       _scrollController.position.maxScrollExtent &&
  //       !_scrollController.position.outOfRange) {
  //     if (curScrollPage < limitedPages) {
  //       setState(() {
  //         isLoading = true;
  //       });
  //       fetchEvents(StoreProvider
  //           .of<AppState>(context)
  //           .state
  //           .token, page: curScrollPage + 1).then((events) {
  //         setState(() {
  //           curScrollPage = curScrollPage + 1;
  //           eventList = events;
  //           isLoading = false;
  //         });
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    // _scrollController = ScrollController();
    // _scrollController.addListener(_scrollListener);
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   var newEventList = await fetchEvents(StoreProvider
    //       .of<AppState>(context)
    //       .state
    //       .token);
    //   setState(() {
    //     // eventList = newEventList;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      onRefresh: () async {
        var result = await fetchEvents(StoreProvider.of<AppState>(context).state.token, isRefresh: true);
        if (result) {
          print("refresh");
          refreshController.refreshCompleted();
        } else {
          refreshController.refreshFailed();
        }
      },
      onLoading: () async {
        var result = await fetchEvents(StoreProvider.of<AppState>(context).state.token);
        if (result) {
          print("load");
          refreshController.loadComplete();
        } else {
          if (curScrollPage > limitedPages) {
            refreshController.loadNoData();
          } else {
            refreshController.loadFailed();
          }
        }
      },
      child: ListView.builder(
        itemCount: eventList.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: EventCard(event: eventList[index],),
          );
        }),
    );
    // return ListView.builder(
    //     controller: _scrollController,
    //     itemCount: isLoading ? eventList.length + 1 : eventList.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       if (index < eventList.length) {
    //         return Container(
    //           padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
    //           child: EventCard(event: eventList[index],),
    //         );
    //       } else {
    //         return const Center(child: CircularProgressIndicator(),);
    //       }
    //     }
    // );
  }
}
