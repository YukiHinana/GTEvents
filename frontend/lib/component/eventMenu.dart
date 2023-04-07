
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class EventMenu extends StatefulWidget {
  final int eventId;
  const EventMenu({super.key, required this.eventId});

  @override
  State<EventMenu> createState() => _EventMenu();
}

enum Option { edit, delete }

class _EventMenu extends State<EventMenu> {
  Option? selectedOption;

  Future<http.Response> sendDeleteEventRequest(String? token) async {
    // if (token == null) {
    //   return null;
    // }
    var response = await http.delete(
      Uri.parse('${Config.baseURL}/events/events/${widget.eventId}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token??""
      },
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        offset: Offset(-15, 40),
        initialValue: selectedOption,
        onSelected: (Option item) {
          setState(() {
            selectedOption = item;
          });
        },
        child: Icon(Icons.more_horiz),
        itemBuilder: (BuildContext context) =>
        <PopupMenuEntry<Option>>[
          PopupMenuItem<Option>(
            // onTap:,
              value: Option.edit,
              child: Text("Edit")
          ),
          PopupMenuItem<Option>(
              onTap: () {
                sendDeleteEventRequest(
                    StoreProvider.of<AppState>(context).state.token)
                    .then((value) {
                      if (value.statusCode == 200) {
                        context.pushReplacement("/events/created");
                      }
                });
              },
              value: Option.delete,
              child: const Text("Delete")
          ),
        ]
    );
  }
}