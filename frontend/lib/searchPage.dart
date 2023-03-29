
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';


import 'config.dart';
import 'eventsPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: TextField(
              decoration: const InputDecoration(
                  labelText: 'search',
                  hintText: 'Enter the username'
              ),
              // controller: _usernameController,
            ),
          ),
        ]
      )
    );
  }
}