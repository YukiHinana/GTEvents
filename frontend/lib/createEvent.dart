
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

class _CreateEventState extends State<CreateEvent> {
  // tag value
  int? value;

  late DateTime dateTime;
  //DateTime currentDate = DateTime.now();
  // final hours = dateTime.hour.toString().padLeft(2, '0');
  // final minutes = dateTime.minute.toString().padLeft(2, '0');

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
    dateTime = DateTime.now();
  }

  Future<http.Response> submitCreateEventRequest(String? token) async {
    var createEventRequest = json.encode(
        {
          'title': _eventTitleController.text,
          'location': _eventLocationController.text,
          'description': _eventDescriptionController.text,
          'eventDate': dateTime.toUtc().millisecondsSinceEpoch/1000,
          'tagIds': value == null ? [] : [value]
        }
    );
    print(dateTime.toUtc().millisecondsSinceEpoch/1000);
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
            'Pick event date and time',
            style: TextStyle(fontSize: 16),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildDatePicker(),
              buildTimePicker(),
            ],
          ),
          const SizedBox(height: 24),
          buildEventCapacityField(),
          const SizedBox(height: 24),
          buildEventFeeField(),
          const SizedBox(height: 24),
          previewCreateEvent(),
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

  Future<List<Tag>> _getEventTags() async {
    var response = await http.get(
      Uri.parse('${Config.baseURL}/tags/'),
      headers: {"Content-Type": "application/json"},
    );
    List<Tag> eventTagList = [];
    if (response.statusCode == 200) {
      for (var i in jsonDecode(utf8.decode(response.bodyBytes))['data']) {
        Map<String, dynamic> map = Map<String, dynamic>.from(i);
        eventTagList.add(Tag(map['id'], map['name']));
      }
    }
    return eventTagList;
  }

  Widget buildCategoryPicker() =>
      FutureBuilder<List<Tag>>(
          future: _getEventTags(),
          builder: (context, snapshot) {
            return DropdownButton<int>(
                isExpanded: true,
                hint: const Text('Pick Category'),
                value: value,
                items: snapshot.data?.map((e) =>
                    DropdownMenuItem<int>(
                      value: e.tagId,
                      child: Text(e.name),
                    )).toList(),
                onChanged: (selectedValue) {
                  setState(() => value = selectedValue);
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
              labelText: 'Enter Event Description',
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
        child: Text('${dateTime.month}/${dateTime.day}/${dateTime.year}'),
        onPressed: () async {
          final date = await pickDate();
          if (date == null) {
            return;
          }
          final newDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            dateTime.hour,
            dateTime.minute,
          );
          setState(() {
            dateTime = newDateTime;
            print(dateTime);
          });
        },
      );

  Future<DateTime?> pickDate() =>
      showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100),
      );

  Widget buildTimePicker() =>
      ElevatedButton(
        child: Text('${dateTime.hour}:${dateTime.minute}'),
        onPressed: () async {
          final time = await pickTime();
          if (time == null) {
            return;
          }
          final newDateTime = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
            time.hour,
            time.minute,
          );
          setState(() {
            dateTime = newDateTime;
            print(dateTime);
          });
        },
      );

  Future<TimeOfDay?> pickTime() =>
      showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );

  Widget buildEventCapacityField() =>
      TextField(
        decoration: const InputDecoration(
          labelText: 'Enter Event Capacity',
          border: OutlineInputBorder(),
        ),
        controller: _eventCapacityController,
      );

  Widget buildEventFeeField() =>
      TextField(
        decoration: const InputDecoration(
          labelText: 'Enter Event Fees',
          border: OutlineInputBorder(),
        ),
        controller: _eventFeeController,
      );

  Widget previewCreateEvent() =>
      FloatingActionButton.extended(
          heroTag: "preview",
          onPressed: () {},
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
              }
            });
          },
          label: const Text("Create")
      );
}