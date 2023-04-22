import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'event.dart';
import 'eventDetailPage.dart';

//Event details page
class EventPreview extends StatefulWidget {
  final String eventTitle;
  final String eventLocation;
  final String eventDescription;
  final String eventDate;
  final String eventCreationDate;
  final List<Tag> tagNameList;

  const EventPreview({super.key, required this.eventTitle,
    required this.eventLocation, required this.eventDescription,
    required this.eventDate, required this.eventCreationDate,
    required this.tagNameList});

  @override
  State<EventPreview> createState() => _EventPreviewState();
}

DateTime date = DateTime.now();
class _EventPreviewState extends State<EventPreview> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Preview"),
      ),
      body: showEventDetails(widget.eventTitle, widget.eventDate,
          widget.eventLocation, widget.eventDescription, widget.tagNameList),
    );
  }
}