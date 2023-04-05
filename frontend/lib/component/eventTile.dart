import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../config.dart';
import '../event.dart';
import 'eventCard.dart';

class EventTile extends StatefulWidget {
  Event event;
  EventTile({super.key, required this.event});

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  late bool eventIsSaved;
  late int eventId;
  late String title;
  late String location;
  late String creationDate;
  late double reverse;

  IconData iconBtnState = Icons.star_border;
  Color iconColorState = Colors.black;
  @override
  void initState() {
    super.initState();
    eventIsSaved = widget.event.isSaved;
    eventId = widget.event.eventId;
    title = widget.event.title;
    location = widget.event.location;
    creationDate = DateFormat('MM/dd/yyyy, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.event.eventCreationTimestamp * 1000));
    // reverse = DateTime.parse(creationDate).toUtc().millisecondsSinceEpoch / 1000;
    reverse = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        fetchEventDetails(eventId).then((value) {
          context.pushNamed("eventDetails",
              params: {
                "id": eventId.toString(),
              },
              queryParams: {
                "eventTitle": value["title"]!,
                "eventLocation": value["location"]!,
                "eventDescription": value["description"]!,
                "eventDate": value["eventDate"].toString(),
                "eventCreationDate": value["eventCreationDate"].toString(),
                "tagName": value["tags"].length == 0 ? "" : value["tags"][0]["name"],
                "isSaved": eventIsSaved.toString(),
              });
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              subtitle: Column(
                children: [
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     "hi",
                  //     // "location: ${DateFormat('MM/dd/yyyy, HH:mm').parse(creationDate).toUtc().millisecondsSinceEpoch/1000}",
                  //     style: const TextStyle(fontSize: 15),
                  //   ),
                  // ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "created on $creationDate"
                    ),
                  )
                ],
              )
            ),
            Row(
              children: [
                const Spacer(),
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                        colors: [Colors.transparent, Colors.black,]
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    height: 100,
                    width: 150,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      image: DecorationImage(
                        opacity: 0.3,
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://picsum.photos/250?image=9'
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}