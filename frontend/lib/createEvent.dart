
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'event.dart';

class CreateEvent extends StatefulWidget{
  const CreateEvent({ Key? key }) : super(key: key);
  
  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent>{
  // tag value
  int? value;
  //DateTime currentDate = DateTime.now();
  DateTime dateTime = DateTime(2023, 03, 28);
  late TextEditingController _eventTitleController;
  late TextEditingController _eventLocationController;
  late TextEditingController _eventDescriptionController;

  @override
  void initState() {
    super.initState();
    _eventTitleController = TextEditingController();
    _eventLocationController = TextEditingController();
    _eventDescriptionController = TextEditingController();
  }

  Future<http.Response> submitCreateEventRequest(String? token) async {
    var createEventRequest = json.encode(
        {
          'title': _eventTitleController.text,
          'location': _eventLocationController.text,
          'description': _eventDescriptionController.text,
          'tagIds': value == null ? [] : [value]
        }
    );
    var response = await http.post(
        Uri.parse('${Config.baseURL}/events/events'),
        headers: {"Content-Type": "application/json", "Authorization": token??""},
        body: createEventRequest
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [
          buildEventTitleField(),
          const SizedBox(height: 24),
          buildEventLocationField(),
          const SizedBox(height: 24),
          buildEventDiscriptionField(),
          const SizedBox(height: 24),
          buildCategoryPicker(),
          const SizedBox(height: 24),
          buildDatePicker(),
          const SizedBox(height: 24),
          previewCreateEvent(),
          const SizedBox(height: 24),
          buildCreateEvent(),

        ],
      ),
    );
  }

  Widget buildEventTitleField() => TextField(
    decoration: InputDecoration(
      labelText: 'Enter Event Title',
      border: OutlineInputBorder(),
    ),
    controller: _eventTitleController,
  );


  Widget buildEventLocationField() => TextField(
    decoration: InputDecoration(
      labelText: 'Enter Event Location',
      border: OutlineInputBorder(),
    ),
    controller: _eventLocationController,
  );
  
  Future<List<Tag>> _getEventTags() async {
    var response = await http.get(
      Uri.parse('${Config.baseURL}/tags/'),
      headers: {"Content-Type": "application/json"},
    );
    List<Tag> eventTagList = [];
    if (response.statusCode == 200) {
      for (var i in jsonDecode(response.body)['data']) {
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
            hint: const Text('Pick Category'),
            value: value,
            items: snapshot.data?.map((e) => DropdownMenuItem<int>(
              value: e.tagId,
              child: Text(e.name),
            )).toList(),
            onChanged: (selectedValue) {
              setState(() => value = selectedValue);
            }
          );
        }
      );

  Widget buildEventDiscriptionField() => TextField(
    decoration: InputDecoration(
      labelText: 'Enter Event Discription',
      border: OutlineInputBorder(),
    ),
     controller: _eventDescriptionController,
     keyboardType: TextInputType.multiline,
     maxLines: null,
  );

  Widget buildDatePicker() => ElevatedButton(
    child: Text('${dateTime.month}/${dateTime.day}/${dateTime.year}'),
    onPressed: () async {
      final date = await pickDate();
      if (date == null) {
        return;
      }
    }, 
  );

  Future<DateTime?> pickDate() => showDatePicker(
    context: context, 
    initialDate: dateTime, 
    firstDate: DateTime(2021), 
    lastDate: DateTime(2100),
  );

  Widget previewCreateEvent() => FloatingActionButton.extended(
    heroTag: "preview",
    onPressed: () {

    }, 
    label: const Text("Preview")
  );

  Widget buildCreateEvent() => FloatingActionButton.extended(
    heroTag: "create",
      onPressed: () {
        var token = StoreProvider.of<AppState>(context).state.token;
        submitCreateEventRequest(token);
      },
      label: const Text("Create")
  );
}