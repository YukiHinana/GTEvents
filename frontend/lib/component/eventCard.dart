import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(StoreProvider.of<AppState>(context).state.userInfo?.username);
        context.push('/events/${widget.eventId}');
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SizedBox(
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: const DecorationImage(
                opacity: 0.3,
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://picsum.photos/250?image=9'
                ),
              ),
            ),
            child: ListTile(
              title: Text(widget.title),
              subtitle: Text(widget.location),
            ),
          ),
        ),
      ),
    );
  }
}
