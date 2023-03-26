import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'homePage.dart';

class SavedEventsPage extends StatefulWidget {
  const SavedEventsPage({super.key});

  @override
  State<SavedEventsPage> createState() => _SavedEventsPage();
}

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
      drawer: UserSideBar(),
    );
  }
}