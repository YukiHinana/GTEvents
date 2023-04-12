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

String mapMonth(String month) {
  switch (month) {
    case "01": {
      return "Jan";
    }
    break;
    case "02": {
      return "Feb";
    }
    break;
    case "03": {
      return "Mar";
    }
    break;
    case "04": {
      return "Apr";
    }
    break;
    case "05": {
      return "May";
    }
    break;
    case "06": {
      return "Jun";
    }
    break;
    case "07": {
      return "Jul";
    }
    break;
    case "08": {
      return "Aug";
    }
    break;
    case "09": {
      return "Sep";
    }
    break;
    case "10": {
      return "Oct";
    }
    break;
    case "11": {
      return "Nov";
    }
    break;
    default: {
      return "Dec";
    }
    break;
  }
}

Widget showEventDetails(String eventTitle, String eventDate,
    String eventLocation, String eventDescription, String tagName) {
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
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 100,
          width: 120,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 35),
                Column(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 40,
                      child: Column(
                        children: [
                          Container(
                            child: Text(month, style: TextStyle(fontSize: 18),),
                          ),
                          Container(
                            child: Text(date, style: TextStyle(fontSize: 16),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Content"),
        actions: <Widget>[
          IconButton(
              //TODO
              onPressed: () {
                setState(() {
                  isSaved = !isSaved;
                });
              },
              icon: isSaved
                  ? const Icon(Icons.star, color: Colors.yellow,)
                  : const Icon(Icons.star_border)),
        ],),
      body: showEventDetails(widget.eventTitle, widget.eventDate,
          widget.eventLocation, widget.eventDescription, widget.tagName),
    );
  }

  @override
  void initState() {
    isSaved = widget.isSaved;
  }
}