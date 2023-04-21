
import 'package:flutter/material.dart';


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
        children: const [
          Padding(
            padding: EdgeInsets.all(48.0),
            child: TextField(
              decoration: InputDecoration(
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