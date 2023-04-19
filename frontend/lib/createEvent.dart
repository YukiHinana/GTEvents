
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'event.dart';

class CreateEvent extends StatefulWidget{
  const CreateEvent({ Key? key }) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

Future<List<Tag>> getEventTags(String? groupName) async {
  var response;
  if (groupName == "") {
    response = await http.get(
      Uri.parse('${Config.baseURL}/tags/'),
      headers: {"Content-Type": "application/json"},
    );
  } else {
    response = await http.get(
      Uri.parse('${Config.baseURL}/tags/group?groupName=$groupName'),
      headers: {"Content-Type": "application/json"},
    );
  }

  List<Tag> eventTagList = [];
  if (response.statusCode == 200) {
    for (var i in jsonDecode(utf8.decode(response.bodyBytes))['data']) {
      Map<String, dynamic> map = Map<String, dynamic>.from(i);
      eventTagList.add(Tag(map['id'], map['name']));
    }
  }
  return eventTagList;
}

class _CreateEventState extends State<CreateEvent> {
  // tag value
  int? tagValue;

  late DateTime eventDateTime;
  late DateTime eventEndTime;
  late TextEditingController _eventTitleController;
  late TextEditingController _eventLocationController;
  late TextEditingController _eventDescriptionController;
  late TextEditingController _eventCapacityController;
  late TextEditingController _eventFeeController;

  @override
  void initState() {
    super.initState();
    _eventTitleController = TextEditingController();
    _eventLocationController = TextEditingController();
    _eventDescriptionController = TextEditingController();
    _eventCapacityController = TextEditingController();
    _eventFeeController = TextEditingController();
    eventDateTime = DateTime.now();
    eventEndTime = DateTime.now();
  }

  Future<http.Response> submitCreateEventRequest(String? token) async {
    var createEventRequest = json.encode(
        {
          'title': _eventTitleController.text,
          'location': _eventLocationController.text,
          'description': _eventDescriptionController.text,
          'eventDate': eventDateTime.toUtc().millisecondsSinceEpoch/1000,
          'tagIds': tagValue == null ? [] : [tagValue]
        }
    );
    var response = await http.post(
        Uri.parse('${Config.baseURL}/events/events'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token ?? ""
        },
        body: createEventRequest
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    // can't save draft
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          buildEventNameField(),
          const SizedBox(height: 20),
          buildEventLocationField(),
          const SizedBox(height: 20),
          buildEventDescriptionField(),
          const SizedBox(height: 20),
          buildCategoryPicker(),
          const SizedBox(height: 20),
          const Text(
            'Pick event date, start time and end time',
            style: TextStyle(fontSize: 16),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildDatePicker(),
              buildTimePicker(),
              buildEndTimePicker(),
            ],
          ),
          const SizedBox(height: 24),
          buildEventCapacityField(),
          const SizedBox(height: 24),
          buildEventFeeField(),
          const SizedBox(height: 24),
          previewCreatedEvent(),
          const SizedBox(height: 24),
          buildCreateEvent(),
        ],
      ),
    );
  }

  Widget buildEventNameField() =>
      Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("* Event Name: (required)", style: TextStyle(fontSize: 16),)
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Enter Event Name',
              border: OutlineInputBorder(),
            ),
            controller: _eventTitleController,
          ),
        ],
      );

  Widget buildEventLocationField() =>
      Column(
        children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text("* Location: (required)", style: TextStyle(fontSize: 16),)
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Enter Event Location',
              border: OutlineInputBorder(),
            ),
            controller: _eventLocationController,
          ),
        ],
      );

  Widget buildCategoryPicker() =>
      FutureBuilder<List<Tag>>(
          future: getEventTags(""),
          builder: (context, snapshot) {
            return DropdownButton<int>(
                isExpanded: true,
                hint: const Text('Pick Category'),
                value: tagValue,
                items: snapshot.data?.map((e) =>
                    DropdownMenuItem<int>(
                      value: e.tagId,
                      child: Text(e.name),
                    )).toList(),
                onChanged: (selectedValue) {
                  setState(() => tagValue = selectedValue);
                }
            );
          }
      );

  Widget buildEventDescriptionField() =>
      Column(
        children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text("* Description: (required)", style: TextStyle(fontSize: 16),)
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Enter Event Details',
              border: OutlineInputBorder(),
            ),
            controller: _eventDescriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ],
      );

  Widget buildDatePicker() =>
      ElevatedButton(
        child: Text('${eventDateTime.month}/${eventDateTime.day}/${eventDateTime.year}'),
        onPressed: () async {
          final date = await pickDate();
          if (date == null) {
            return;
          }
          final newDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            eventDateTime.hour,
            eventDateTime.minute,
          );
          setState(() {
            eventDateTime = newDateTime;
          });
        },
      );

  Future<DateTime?> pickDate() =>
      showDatePicker(
        context: context,
        initialDate: eventDateTime,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100),
      );

  Widget buildTimePicker() =>
      ElevatedButton(
        child: Text('${eventDateTime.hour}:${eventDateTime.minute}'),
        onPressed: () async {
          final time = await pickTime();
          if (time == null) {
            return;
          }
          final newDateTime = DateTime(
            eventDateTime.year,
            eventDateTime.month,
            eventDateTime.day,
            time.hour,
            time.minute,
          );
          setState(() {
            eventDateTime = newDateTime;
          });
        },
      );

  Future<TimeOfDay?> pickTime() =>
      showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: eventDateTime.hour, minute: eventDateTime.minute),
      );
  Widget buildEndTimePicker() {
    return ElevatedButton(
      child: Text('${eventEndTime.hour}:${eventEndTime.minute}'),
        onPressed: () async {
          final time = await pickTime();
          if (time == null) {
            return;
          }
          final newDateTime = DateTime(
            eventEndTime.year,
            eventEndTime.month,
            eventEndTime.day,
            time.hour,
            time.minute,
          );
          setState(() {
            eventEndTime = newDateTime;
          });
        },
      );
  }
  Widget buildEventCapacityField() {
    return Column(
      children: [
        const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Capacity: (optional)", style: TextStyle(fontSize: 16),)
        ),
        const SizedBox(height: 5),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Enter Capacity',
            border: OutlineInputBorder(),
          ),
          controller: _eventCapacityController,
        ),
      ],
    );
  }

  Widget buildEventFeeField() =>
      Column(
        children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Fee: (optional)", style: TextStyle(fontSize: 16),)
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Enter Event Fees',
              border: OutlineInputBorder(),
            ),
            controller: _eventFeeController,
          ),
        ],
      );

  Widget previewCreatedEvent() =>
      FloatingActionButton.extended(
          heroTag: "preview",
          onPressed: () {
            context.pushNamed("eventPreview",
                queryParams: {
                  "eventTitle": _eventTitleController.text,
                  "eventLocation": _eventLocationController.text,
                  "eventDescription": _eventDescriptionController.text,
                  "eventDate": (eventDateTime.toUtc().millisecondsSinceEpoch/1000).toString(),
                  "tagName": tagValue == null ? [] : [tagValue],
                  "isSaved": false.toString(),
                }
            );
          },
          label: const Text("Preview")
      );

  Widget buildCreateEvent() =>
      FloatingActionButton.extended(
          heroTag: "create",
          onPressed: () {
            var token = StoreProvider
                .of<AppState>(context)
                .state
                .token;
            submitCreateEventRequest(token).then((value) {
              if (value.statusCode == 200) {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>
                        AlertDialog(
                          content: const Text("Event successfully created"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  var event = jsonDecode(value.body)['data'];
                                  context.pushReplacementNamed("eventDetails",
                                      params: {
                                        "id": event['id'].toString(),
                                      },
                                      queryParams: {
                                        "eventTitle": event["title"]!,
                                        "eventLocation": event["location"]!,
                                        "eventDescription": event["description"]!,
                                        "tagName": event["tags"].length == 0 ? "" : event["tags"][0]["name"],
                                        "isSaved": false.toString(),
                                      }
                                  );
                                },
                                child: const Text('OK'))
                          ],
                        )
                );
              } else {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>
                        AlertDialog(
                          content: const Text("Failed to create event, try again"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text('OK'))
                          ],
                        )
                );
              }
            });
          },
          label: const Text("Create")
      );
}