
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
  late String eventDate;

  IconData iconBtnState = Icons.star_border;
  Color iconColorState = Colors.black;
  @override
  void initState() {
    super.initState();
    eventIsSaved = widget.event.isSaved;
    eventId = widget.event.eventId;
    title = widget.event.title;
    location = widget.event.location;
    creationDate = DateFormat('MM/dd/yyyy, HH:mm').format(
        DateTime.fromMillisecondsSinceEpoch(
            widget.event.eventCreationTimestamp * 1000));
    eventDate = DateFormat('MM/dd/yyyy, HH:mm').format(
        DateTime.fromMillisecondsSinceEpoch(
            widget.event.eventDateTimestamp * 1000));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO:!!!!!!
        fetchEventDetails(eventId).then((value) {
          Event e = Event(
              value['id'],
              value['title'],
              value['location'],
              value['description'],
              value['eventDate'] ?? 0,
              value['capacity'],
              value['fee'],
              false,
              value['eventCreationDate'] ?? 0,
              value['author']['username']);
          List<Tag> tList = [];
          for (var i = 0; i < value['tags'].length; i++) {
            tList.add(Tag(value['tags'][i]['id'],
                value['tags'][i]['name']));
          }
          Map<String, dynamic> paramMap = <String, dynamic>{};
          paramMap.putIfAbsent("event", () => e);
          paramMap.putIfAbsent("tagList", () => tList);
          context.pushReplacementNamed(
              "eventDetails", extra: paramMap);
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "event date: $eventDate"
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
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
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