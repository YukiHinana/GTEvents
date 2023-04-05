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

DateTime date = DateTime.now();
class _EventDetailPageState extends State<EventDetailPage> {

  String _convertTimestampToDate(String str) {
    return DateFormat('MM/dd/yyyy, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(str) * 1000));
  }

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
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.eventTitle,
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
            child: Text(
              _convertTimestampToDate(widget.eventDate),
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
              widget.eventLocation,
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
              widget.eventDescription,
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
              widget.tagName == "" ? "None" : widget.tagName,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}