import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class EventCard extends StatefulWidget {
  final int eventId;
  final String title;
  final String location;
  const EventCard({super.key, required this.eventId, required this.title, required this.location});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {

  Widget eventImgCard = Container(
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
  void toggleIconBtnState(int eventId, String? token) {
    if (iconBtnState == Icons.star_border) {
      iconBtnState = Icons.star;
      iconColorState = Colors.yellow;
      saveEventRequest(eventId, token);
    } else {
      iconBtnState = Icons.star_border;
      iconColorState = Colors.black;
      deleteSavedEventRequest(eventId, token);
    }
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
        context.push('/events/${widget.eventId}');
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
            eventImgCard,
            Container(
              height: 80,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                color: Colors.white60,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 7.0),
                        child: Text(
                          widget.title,
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                      subtitle: Text(
                        "location: ${widget.location}",
                        style: const TextStyle(fontSize: 15),
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
                              toggleIconBtnState(widget.eventId, token);
                            });
                          },
                          icon: Icon(iconBtnState, size: 40, color: iconColorState,)
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