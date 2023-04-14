import 'dart:convert';

import 'package:GTEvents/component/tagCard.dart';
import 'package:GTEvents/eventDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../event.dart';

class EventCard extends StatefulWidget {
  Event event;
  List<Tag> tagList;
  EventCard({super.key, required this.event, required this.tagList});
  // EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

Future<Map<String, dynamic>> fetchEventDetails(int eventId) async {
  var response = await http.get(
    Uri.parse('${Config.baseURL}/events/events/$eventId'),
    headers: {"Content-Type": "application/json"},
  );
  Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(utf8.decode(response.bodyBytes))['data']);
  return map;
}

List<Widget> getTagCards(List<Tag> tags) {
  List<Widget> list = [];
  for (int i = 0; i < tags.length; i++) {
    list.add(
        TagCard(tag: tags[i])
    );
  }
  return list;
}

class _EventCardState extends State<EventCard> {
  List<Tag> tags = [];
  late bool eventIsSaved;
  late int eventId;
  late String eventTitle;
  late String location;
  late String organizer;
  late int eventDate;

  IconData iconBtnState = Icons.star_border;
  Color iconColorState = Colors.black;

  @override
  void initState() {
    super.initState();
    if (widget.event.isSaved) {
      iconBtnState = Icons.star;
      iconColorState = Colors.yellow;
    }
    eventIsSaved = widget.event.isSaved;
    eventId = widget.event.eventId;
    eventTitle = widget.event.title;
    location = widget.event.location;
    organizer = widget.event.organizer;
    eventDate = widget.event.eventDateTimestamp;
    tags = widget.tagList;
  }

  Future<http.Response> saveEventRequest(int eventId, String? token) async {
    var response = await http.post(
      Uri.parse('${Config.baseURL}/events/saved/$eventId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token ?? ""
      },
    );
    return response;
  }

  Future<http.Response> deleteSavedEventRequest(int eventId,
      String? token) async {
    var response = await http.delete(
      Uri.parse('${Config.baseURL}/events/saved/$eventId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token ?? ""
      },
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    String month = "";
    String date = "";
    String time = "";
    if (eventDate != 0) {
      List<String> eventTimeList = convertTimestampToDate(eventDate.toString())
          .split('/');
      month = mapMonth(eventTimeList[0]);
      date = eventTimeList[1];
      //split year and time
      time = eventTimeList[2].split(', ')[1];
    }

    return GestureDetector(
      onTap: () {
        fetchEventDetails(eventId).then((value) {
          Map<String, dynamic> paramMap = <String, dynamic>{};
          paramMap.putIfAbsent("event", () => widget.event);
          paramMap.putIfAbsent("tagList", () => widget.tagList);
          context.pushNamed("eventDetails", extra: paramMap);
        });
      },
      child: Column(
        children: [
          // event title and time
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  margin: const EdgeInsets.all(0),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery
                          .of(context)
                          .size
                          .width * 0.7,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xffa8dcda),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 4, 5, 2),
                      child: Text(
                        eventTitle,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
              ),
              const Spacer(),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                color: const Color(0xff7e6352),
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: Column(
                    children: [
                      // TODO: convert 24 hour time to AM/PM
                      Text("$month.$date", style: const TextStyle(
                          fontSize: 17, color: Color(0xffe9f5db)),),
                      const SizedBox(height: 4,),
                      Text("@ $time", style: const TextStyle(
                          fontSize: 15, color: Color(0xffe9f5db)),),
                    ],
                  ),
                ),
              )
            ],
          ),
          // event card body (image and other info)
          Card(
            elevation: 10,
            shadowColor: const Color(0xffD4A373),
            margin: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                // event image
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      opacity: 0.3,
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://picsum.photos/250?image=9'
                      ),
                    ),
                  ),
                ),
                // event other info
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    color: Colors.white70,
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                            child: Text("Location: $location",
                              style: const TextStyle(fontSize: 17),),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 3, 0, 3),
                            child: Text("Organizer: $organizer",
                                style: const TextStyle(fontSize: 17)),
                          ),
                          // list event tags
                          Row(
                            children: getTagCards(tags),
                          )
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            padding: const EdgeInsets.fromLTRB(
                                0, 15.0, 10.0, 0),
                            onPressed: () {
                              var token = StoreProvider
                                  .of<AppState>(context)
                                  .state
                                  .token;
                              setState(() {
                                eventIsSaved = !eventIsSaved;
                                if (eventIsSaved) {
                                  iconBtnState = Icons.star;
                                  iconColorState = Colors.yellow;
                                  saveEventRequest(eventId, token);
                                } else {
                                  iconBtnState = Icons.star_border;
                                  iconColorState = Colors.black;
                                  deleteSavedEventRequest(eventId, token);
                                }
                              });
                            },
                            icon: eventIsSaved ? const Icon(
                              Icons.star, size: 40, color: Colors.yellow,) :
                            const Icon(Icons.star_border, size: 40,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}