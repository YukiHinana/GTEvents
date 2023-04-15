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
  print(response);
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