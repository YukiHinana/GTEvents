
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'createEvent.dart';

import 'component/sidebar.dart';
//Create event page class
class CreatedEventsPage extends StatefulWidget {
  const CreatedEventsPage({super.key});

  @override
  State<CreatedEventsPage> createState() => _CreatedEventsPage();
}
//Route webpage to create event site
class _CreatedEventsPage extends State<CreatedEventsPage> {
  void navigateEventCreation(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_){
      return const CreateEvent();
    }));
  }

  //Create event page interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events Created'),
        actions: <Widget>[
          IconButton(
              onPressed: () => context.go('/events'),
              icon: const Icon(Icons.home))
        ],
      ),
      drawer: const UserSideBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push("/events/create"),
        // onPressed: () {
        //   navigateEventCreation(context);
        // },
        label: const Text("Create New Event"),
      ),
    );
  }
}