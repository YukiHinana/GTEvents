import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../event.dart';

class EventCard extends StatefulWidget {
  Event event;
  EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

Future<Map<String, dynamic>> fetchEventDetails(int eventId) async {
  var response = await http.get(
    Uri.parse('${Config.baseURL}/events/events/$eventId'),
    headers: {"Content-Type": "application/json"},
  );
  Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(utf8.decode(response.bodyBytes))['data']);
  return map;
}

class _EventCardState extends State<EventCard> {
  late bool eventIsSaved;
  late int eventId;
  late String title;
  late String location;

  final Widget _eventImgCard = Container(
    height: 250,
    decoration:  const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      image: DecorationImage(
        opacity: 0.3,
        fit: BoxFit.fill,
        image: NetworkImage(
            'https://picsum.photos/250?image=9'
        ),
      ),
    ),
  );

  IconData iconBtnState = Icons.star_border;
  Color iconColorState = Colors.black;
  @override
  void initState() {
    super.initState();
    if (widget.event.isSaved) {
      iconBtnState = Icons.star;
      iconColorState = Colors.yellow;
    }
    eventIsSaved = widget.event.isSaved;
    eventId = widget.event.eventId;
    title = widget.event.title;
    location = widget.event.location;
  }

  Future<http.Response> saveEventRequest(int eventId, String? token) async{
    var response = await http.post(
      Uri.parse('${Config.baseURL}/events/saved/$eventId'),
      headers: {"Content-Type": "application/json", "Authorization": token??""},
    );
    return response;
  }

  Future<http.Response> deleteSavedEventRequest(int eventId, String? token) async{
    var response = await http.delete(
      Uri.parse('${Config.baseURL}/events/saved/$eventId'),
      headers: {"Content-Type": "application/json", "Authorization": token??""},
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        fetchEventDetails(eventId).then((value) {
          context.pushNamed("eventDetails",
              params: {
                "id": eventId.toString(),
              },
              queryParams: {
                "eventTitle": value["title"]!,
                "eventLocation": value["location"]!,
                "eventDescription": value["description"]!,
                "eventDate": (value["eventDate"]??0).toString(),
                "eventCreationDate": (value["eventCreationDate"]??0).toString(),
                "tagName": value["tags"].length == 0 ? "" : value["tags"][0]["name"],
                "isSaved": eventIsSaved.toString(),
              });
        });
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            _eventImgCard,
            Container(
              height: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                color: Colors.white70,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 350,
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 7.0),
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: 25, fontFamily: "Google Sans"),
                        ),
                      ),
                      subtitle: Text(
                        "location: $location",
                        style: const TextStyle(fontSize: 15, color: Color(0xff01012d)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        padding: const EdgeInsets.fromLTRB(0, 5.0, 10.0, 0),
                        onPressed: () {
                          var token = StoreProvider.of<AppState>(context).state.token;
                          setState(() {
                            eventIsSaved = !eventIsSaved;
                            if (eventIsSaved) {
                              iconBtnState = Icons.star;
                              iconColorState = Colors.yellow;
                              saveEventRequest(eventId, token);
                            } else {
                              iconBtnState = Icons.star_border;
                              iconColorState = Colors.black;
                              deleteSavedEventRequest(eventId, token);
                            }
                          });
                        },
                        icon: eventIsSaved ? const Icon(Icons.star, size: 40, color: Colors.yellow,) :
                        const Icon(Icons.star_border, size: 40,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}