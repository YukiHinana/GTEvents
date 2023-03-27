import 'package:GTEvents/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'component/sidebar.dart';

class CreatedEventsPage extends StatefulWidget {
  const CreatedEventsPage({super.key});

  @override
  State<CreatedEventsPage> createState() => _CreatedEventsPage();
}

class _CreatedEventsPage extends State<CreatedEventsPage> {
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
      drawer: UserSideBar(),
    );
  }
}