import 'dart:convert';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import 'config.dart';

class Event {
  int eventId;
  String title;
  String location;
  String description;
  int eventDateTimestamp;
  int capacity;
  int fee;
  bool isSaved;
  int eventCreationTimestamp;
  String organizer;

  Event(this.eventId, this.title, this.location, this.description, this.eventDateTimestamp,
      this.capacity, this.fee, this.isSaved, this.eventCreationTimestamp, this.organizer);

  factory Event.fromJson(dynamic json) {
    return Event(json['id'] as int, json['title'] as String,
        json['location'] as String, json['description'] as String,
        json['eventDate'] as int,
        json['capacity'] as int,
        json['fee'] as int, false,
        json['eventCreationDate'] as int,
        json['author']['username'] as String
    );
  }

  void setIsSaved(bool isSaved) {
    this.isSaved = isSaved;
  }

  @override
  String toString() {
    return'{$eventId, $title, $location, $description, $capacity, $fee}';
  }

  // bool operator == (e) => e is Event && eventId == e.eventId && title == e.title;
}

class Tag {
  int tagId;
  String name;
  Tag(this.tagId, this.name);
  factory Tag.fromJson(dynamic json) {
    return Tag(json['id'] as int, json['name'] as String);
  }

  @override
  String toString() {
    return'{$tagId, $name}';
  }
}

Future<Map<String, dynamic>> fetchEventDetails(int eventId) async {
  var response = await http.get(
    Uri.parse('${Config.baseURL}/events/events/$eventId'),
    headers: {"Content-Type": "application/json"},
  );
  Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(utf8.decode(response.bodyBytes))['data']);
  return map;
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

String convertTimestampToDate(String str) {
  return DateFormat('MM/dd/yyyy, HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch((double.parse(str) * 1000).toInt()));
}

String mapMonth(String month) {
  if (month == "01" || month == "1") {
    return "Jan";
  } else if (month == "02" || month == "2") {
    return "Feb";
  } else if (month == "03" || month == "3") {
    return "Mar";
  } else if (month == "04" || month == "4") {
    return "Apr";
  } else if (month == "05" || month == "5") {
    return "May";
  } else if (month == "06" || month == "6") {
    return "Jun";
  } else if (month == "07" || month == "7") {
    return "Jul";
  } else if (month == "08" || month == "8") {
    return "Aug";
  } else if (month == "09" || month == "9") {
    return "Sep";
  } else if (month == "10") {
    return "Oct";
  } else if (month == "11") {
    return "Nov";
  } else {
    return "Dec";
  }
}