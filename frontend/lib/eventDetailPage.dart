import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Event details page
class EventDetailPage extends StatefulWidget {
  final String eventTitle;
  final String eventLocation;
  final String eventDescription;
  final String eventDate;
  final String eventCreationDate;
  final String tagName;
  final bool isSaved;

  const EventDetailPage({super.key, required this.eventTitle,
    required this.eventLocation, required this.eventDescription,
    required this.eventDate, required this.eventCreationDate,
    required this.tagName, required this.isSaved});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

String convertTimestampToDate(String str) {
  return DateFormat('MM/dd/yyyy, HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch((double.parse(str) * 1000).toInt()));
}

Widget showEventDetails(String eventTitle, String eventDate,
    String eventLocation, String eventDescription, String tagName) {
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
      Container(
        padding: const EdgeInsets.all(8.0),
        child: const Text(
          'Date and Time',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        child: eventDate == "0" ?
        const Text("Event date here",
            style: TextStyle(fontSize: 16))
            :
        Text(
          convertTimestampToDate(eventDate),
          style: const TextStyle(fontSize: 16),
        ),
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
        child: Text(
          tagName == "" ? "None" : tagName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ],
  );
}

DateTime date = DateTime.now();
class _EventDetailPageState extends State<EventDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Content"),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: widget.isSaved
                  ? const Icon(Icons.star, color: Colors.yellow,)
                  : const Icon(Icons.star_border)),
        ],),
      body: showEventDetails(widget.eventTitle, widget.eventDate,
          widget.eventLocation, widget.eventDescription, widget.tagName),
    );
  }
}