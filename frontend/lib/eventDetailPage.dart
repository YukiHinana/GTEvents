import 'package:flutter/material.dart';

//Event details page
class EventDetailPage extends StatefulWidget {
  // final int eventId;
  // const EventDetailPage({super.key, required this.eventId});
  final String eventTitle;
  final String eventLocation;
  final String eventDescription;
  final String tagName;

  const EventDetailPage({super.key, required this.eventTitle,
    required this.eventLocation, required this.eventDescription,
    required this.tagName});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

// String eventTitle = 'Sting Break';
// String eventLocaion = 'Tech Green';
// String eventDiscription = 'Prepare yourselves Yellow Jackets 🐝 — Join us on a prehistoric journey for Sting Break Before Time on Thursday, March 30th from 7-11pm at Tech Green & W21 Parking Lot! Get ready for a thrilling night filled with prehistoric-themed activities and rides, carnival games, delicious food, and a scavenger hunt for a chance to win FREE tickets to GT Night at Six Flags! Sting Break tickets are free and will go live on Campus Tickets starting Sunday, March 26th at noon!';
// String eventCategory = 'Social';
DateTime date = DateTime.now();
//Event detail page interface
class _EventDetailPageState extends State<EventDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.eventTitle.toString())),
        body: ListView(
          children: [
            // Container(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     widget.eventTitle,
            //     textAlign: TextAlign.center,
            //     style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
            //   ),
            //
            // ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Date and Time',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                '03/30/2023',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                '7:00 pm',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Location',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.eventLocation,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Description',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.eventDescription,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Catagory',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.tagName,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
    );
  }
}