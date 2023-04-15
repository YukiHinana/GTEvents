import 'package:flutter/material.dart';

import 'component/eventCard.dart';
import 'event.dart';

//Event details page
class EventDetailPage extends StatefulWidget {
  final Event event;
  final List<Tag> tagList;
  const EventDetailPage({super.key, required this.event, required this.tagList});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

Widget showEventDetails(String eventTitle, String eventDate,
    String eventLocation, String eventDescription, List<Tag> tagList) {
  String month = "";
  String date = "";
  if (eventDate != "0") {
    List<String> eventTimeList = convertTimestampToDate(eventDate).split('/');
    month = mapMonth(eventTimeList[0]);
    date = eventTimeList[1];
  }

  return ListView(
    children: [
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          eventTitle == "" ? "Title here" : eventTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Row(
        children: [
          // event date
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 90,
              width: 85,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: const Color(0xffc0a486),
                child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: Text(month, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),),
                          ),
                          Container(
                            child: Text(date, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                          )
                        ],
                      ),
                    ),
              ),
            ),
          ),
          // event time and location
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(Icons.calendar_today, size: 35),
                ),
                eventDate == "0" ?
                const Text("Event date here",
                    style: TextStyle(fontSize: 16))
                    :
                Text(
                  convertTimestampToDate(eventDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

          ),
        ],
      ),

      Container(
        padding: const EdgeInsets.all(8.0),
        child: const Text(
          'Location',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          eventLocation == "" ? "event location here" : eventLocation,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        child: const Text(
          'Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          eventDescription == "" ? "event details here" : eventDescription,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        child: const Text(
          'Category',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [...getTagCards(tagList)],
        )
      ),
    ],
  );
}

DateTime date = DateTime.now();
class _EventDetailPageState extends State<EventDetailPage> {
  // bool isSaved = false;
  late Event event;
  List<Tag> tagList = [];

  @override
  Widget build(BuildContext context) {
    // print(tagList);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Content"),
        actions: <Widget>[
          IconButton(
              //TODO
              onPressed: () {
                setState(() {
                  // isSaved = !isSaved;
                });
              },
              icon: event.isSaved
                  ? const Icon(Icons.star, color: Colors.yellow,)
                  : const Icon(Icons.star_border)),
        ],),
      body: showEventDetails(event.title, event.eventDateTimestamp.toString(),
          event.location, event.description, tagList),
    );
  }

  @override
  void initState() {
    super.initState();
    event = widget.event;
    tagList = widget.tagList;
  }
}