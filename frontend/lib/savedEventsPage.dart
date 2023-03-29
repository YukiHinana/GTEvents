import 'package:GTEvents/component/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//SavedEventsPage
class SavedEventsPage extends StatefulWidget {
  const SavedEventsPage({super.key});

  @override
  State<SavedEventsPage> createState() => _SavedEventsPage();
}
//SavedEventsPage interface
class _SavedEventsPage extends State<SavedEventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Events'),
        actions: <Widget>[
          IconButton(
              onPressed: () => context.go('/events'),
              icon: const Icon(Icons.home))
        ],
      ),
      drawer: const UserSideBar(),
    );
  }
}