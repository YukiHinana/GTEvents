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

const _PAGE_SIZE = 8;

/// This structure represents a paged fetch result.
class PagedResult<T> {
  int pageNumber;
  int totalPages;
  int totalElements;
  List<T> items = [];
  Map tagItems = <int, List<Tag>>{};

  PagedResult(
      {this.pageNumber = 0, this.totalPages = 0, this.totalElements = 0});
}

//Event Page
class _EventsPage extends State<EventsPage> {
  // States
  List<Event> eventList = [];
  Map tagMap = <int, List<Tag>>{};
  int totalPages = 0;
  int curScrollPage = 0;

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  /// Returns a future which resolves to List<Event>?.
  Future<PagedResult<Event>?> fetchEvents(String? token, int pageNumber) async {
    List<Event> newEventList = [];
    Map newTagMap = <int, List<Tag>>{};
    var response = await http.get(
      Uri.parse(
          '${Config.baseURL}/events/events/sort/event-date?pageNumber=$pageNumber&pageSize=$_PAGE_SIZE'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      PagedResult<Event> result = PagedResult();
      Map<String, dynamic> map =
          Map<String, dynamic>.from(jsonDecode(utf8.decode(response.bodyBytes))['data']);
      result.totalPages = map['totalPages'];
      result.pageNumber = map['number'];
      result.totalElements = map['totalElements'];
      List<dynamic> fetchResult = map['content'];
      // decide whether an event needs to show stared icon
      List<Event> savedEventList = await fetchSavedEvents(token);
      for (var info in fetchResult) {
        var isSaved = false;
        for (Event e in savedEventList) {
          if (e.eventId == info['id']) {
            isSaved = true;
          }
        }
        for (var i = 0; i < info['tags'].length; i++) {
          if (newTagMap[info['id']] != null) {
            List<Tag> curTagList = newTagMap[info['id']];
            curTagList.add(Tag(info['tags'][i]['id'], info['tags'][i]['name']));
          } else {
            newTagMap[info['id']] = [Tag(info['tags'][i]['id'], info['tags'][i]['name'])];
          }
        }
        newEventList.add(Event(info['id'], info['title'], info['location'],
            info['description'], info['eventDate']??0, info['capacity'],
            info['fee'], isSaved,
            info['eventCreationDate']??0, info['author']['username']));
      }
      result.tagItems = newTagMap;
      result.items = newEventList;
      return result;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      onRefresh: () async {
        // Call fetchEvents with 0, to get the initial page
        var result = await fetchEvents(
            StoreProvider.of<AppState>(context).state.token, 0);
        if (result != null) {
          // Fetch succeed, update state and trigger re-render
          setState(() {
            eventList = result.items;
            tagMap = result.tagItems;
            totalPages = result.totalPages;
            curScrollPage = result.pageNumber;

            refreshController.resetNoData();
            refreshController.refreshCompleted();
          });
        } else {
          // Null is failed fetch for whatever reason
          refreshController.refreshFailed();
        }
      },
      onLoading: () async {
        if ((curScrollPage + 1) < totalPages) {
          // Has next page
          var result = await fetchEvents(
              StoreProvider.of<AppState>(context).state.token,
              curScrollPage + 1);
          if (result != null) {
            setState(() {
              eventList = [...eventList, ...result.items];
              tagMap = {...tagMap, ...result.tagItems};
              totalPages = result.totalPages;
              curScrollPage = result.pageNumber;

              refreshController.loadComplete();
            });
          } else {
            refreshController.loadFailed();
          }
        } else {
          refreshController.loadNoData();
        }
      },
      child: ListView.builder(
          itemCount: eventList.length,
          itemBuilder: (context, index) {
            return Container(
              key: Key("${eventList[index].eventId}"),
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: EventCard(
                event: eventList[index],
                tagList: tagMap[eventList[index].eventId]??[],
              ),
            );
          }),
    );
  }
}
