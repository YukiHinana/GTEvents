
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'config.dart';
import 'event.dart';

class CreateEvent extends StatefulWidget{
  const CreateEvent({ Key? key }) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

// TODO: delete nullable
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
  // allow to select up to 3 tags
  // TODO: remember to set the limit on backend
  List<Tag?> selectedTagList = [null, null, null];
  List<Tag> providedTagList = [];

  late File _image1;
  late File _image2;
  late File _image3;
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
    Future.delayed(Duration.zero, () async {
      providedTagList = await getEventTags("");
    });
    // eventEndTime = DateTime.now();
  }

  Future<http.Response> submitCreateEventRequest(String? token) async {
    List<int> tagIdList = [];
    for (Tag? t in selectedTagList) {
      if (t != null) {
        tagIdList.add(t.tagId);
      }
    }
    var createEventRequest = json.encode(
        {
          'title': _eventTitleController.text,
          'location': _eventLocationController.text,
          'description': _eventDescriptionController.text,
          'eventDate': eventDateTime
              .toUtc()
              .millisecondsSinceEpoch / 1000,
          'tagIds': tagIdList
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
          buildTagPicker(0),
          buildTagPicker(1),
          buildTagPicker(2),
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
              // TODO: ignore this for now
              // buildEndTimePicker(),
            ],
          ),
          /*ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildImagePicker(onClick: getImage1),
              buildImagePicker(onClick: getImage2),
              buildImagePicker(onClick: getImage3),
            ],
          ),*/
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
              child: Text(
                "* Event Name: (required)", style: TextStyle(fontSize: 16),)
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
              child: Text(
                "* Location: (required)", style: TextStyle(fontSize: 16),)
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

  String tagOrigHint = "Pick Category";

  Widget buildTagPicker(int index) {
    return FutureBuilder<List<Tag>>(
        future: getEventTags(""),
        builder: (context, snapshot) {
          return DropdownButton<Tag>(
              isExpanded: true,
              hint: Text((selectedTagList[index] == null)
                  ? "Pick Category"
                  : selectedTagList[index]!.name),
              items: snapshot.data?.map((e) =>
                  DropdownMenuItem<Tag>(
                    value: e,
                    child: Text(e.name),
                  )).toList(),
              onChanged: (selectedValue) {
                setState(() {
                  if (selectedValue != null) {
                    selectedTagList[index] = selectedValue;
                  }
                });
              }
          );
        }
    );
  }

  Widget buildEventDescriptionField() =>
      Column(
        children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "* Description: (required)", style: TextStyle(fontSize: 16),)
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

  Widget buildImagePicker({required VoidCallback onClick}) {
    return ElevatedButton(
        onPressed: onClick,
        child: Text('Pick an image')
    );
  }

  Future getImage1() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    final imageTemp = File(image.path);
    setState(() {
      this._image1 = imageTemp;
      var token = StoreProvider
                .of<AppState>(context)
                .state
                .token;
      sendPic(File(_image1.path), token);
    });
  }

  Future getImage2() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    final imageTemp = File(image.path);
    setState(() {
      this._image2 = imageTemp;
      var token = StoreProvider
                .of<AppState>(context)
                .state
                .token;
      sendPic(File(_image2.path), token);
      
    });
  }

  Future getImage3() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    final imageTemp = File(image.path);
    setState(() {
      this._image3 = imageTemp;
      var token = StoreProvider
                .of<AppState>(context)
                .state
                .token;
      sendPic(File(_image3.path), token);
    });
  }

  Future<void> sendPic(File img, String? token) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(img.path),
    });
    Dio dio = new Dio();
    var response = await dio.post(
        '${Config.baseURL}/account/avatar',
        data: formData,
        options: Options(headers: {
          "Authorization": token??"",
        }),
    );
  }
  Widget buildDatePicker() =>
      ElevatedButton(
        child: Text('${eventDateTime.month}/${eventDateTime.day}/${eventDateTime
            .year}'),
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
        initialTime: TimeOfDay(
            hour: eventDateTime.hour, minute: eventDateTime.minute),
      );
  // Widget buildEndTimePicker() {
  //   return ElevatedButton(
  //     child: Text('${eventEndTime.hour}:${eventEndTime.minute}'),
  //       onPressed: () async {
  //         final time = await pickTime();
  //         if (time == null) {
  //           return;
  //         }
  //         final newDateTime = DateTime(
  //           eventEndTime.year,
  //           eventEndTime.month,
  //           eventEndTime.day,
  //           time.hour,
  //           time.minute,
  //         );
  //         setState(() {
  //           eventEndTime = newDateTime;
  //         });
  //       },
  //     );
  // }

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

  Widget previewCreatedEvent() {
    Map<String, dynamic> paramMap = <String, dynamic>{};
    List<Tag> tList = [];
    for (var i = 0; i < selectedTagList.length; i++) {
      if (selectedTagList[i] != null) {
        tList.add(Tag(selectedTagList[i]!.tagId,
            selectedTagList[i]!.name));
      }
    }
    paramMap.putIfAbsent("tagList", () => tList);

    return FloatingActionButton.extended(
        heroTag: "preview",
        onPressed: () {
          context.pushNamed("eventPreview",
              queryParams: {
                "eventTitle": _eventTitleController.text,
                "eventLocation": _eventLocationController.text,
                "eventDescription": _eventDescriptionController.text,
                "eventDate": (eventDateTime.toUtc().millisecondsSinceEpoch/1000).toString(),
                "capacity": _eventCapacityController.text == ""
                    ? "0" : _eventCapacityController.text,
                "fee": _eventFeeController.text == ""
                    ? "0" : _eventFeeController.text,
                "isSaved": false.toString(),
              },
              extra: paramMap
          );
        },
        label: const Text("Preview")
    );
  }

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
                                  Map<String, dynamic> map = Map<String,
                                      dynamic>.from(jsonDecode(
                                      value.body)['data']);

                                  Map<String, dynamic> paramMap = <
                                      String,
                                      dynamic>{};

                                  Event e = Event(
                                      map['id'],
                                      map['title'],
                                      map['location'],
                                      map['description'],
                                      map['eventDate'] ?? 0,
                                      map['capacity'],
                                      map['fee'],
                                      false,
                                      map['eventCreationDate'] ?? 0,
                                      map['author']['username']);
                                  List<Tag> tList = [];
                                  for (var i = 0; i < map['tags'].length; i++) {
                                    tList.add(Tag(map['tags'][i]['id'],
                                        map['tags'][i]['name']));
                                  }
                                  paramMap.putIfAbsent("event", () => e);
                                  paramMap.putIfAbsent("tagList", () => tList);
                                  context.pushReplacementNamed(
                                      "eventDetails", extra: paramMap);
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
                          content: const Text(
                              "Failed to create event, try again"),
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