import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String location;
  const EventCard({super.key, required this.title, required this.location});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: SizedBox(
        height: 200,
        width: 250,
        child: (Text('aa')),
      ),
    );
  }
}
