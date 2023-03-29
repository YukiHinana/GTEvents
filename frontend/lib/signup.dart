import 'dart:convert';

import 'package:GTEvents/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class MySignupPage extends StatefulWidget {
  const MySignupPage({super.key});

  @override
  State<MySignupPage> createState() => _MySignupState();
}

class _MySignupState extends State<MySignupPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  Future<http.Response> sendSignupRequest() async {
    var signupData = json.encode(
        {
          'username': _usernameController.text,
          'password': _passwordController.text,
          'isOrganizer': true,
        }
    );
    var response = await http.post(
        Uri.parse('${Config.baseURL}/account/register'),
        headers: {"Content-Type": "application/json"},
        body: signupData
    );
    return response;
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test SignUp Page'),
      ),
      body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                    labelText: 'UserName',
                    hintText: 'Enter the username'
                ),
                controller: _usernameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter the password'
                ),
                controller: _passwordController,
              ),
            ),

            Container(
              height: 50,
              child: ElevatedButton(
                child: const Text('SignUp'),
                onPressed: () {
                  Future<http.Response> res = sendSignupRequest();
                  res.then((value) {
                    if (value.statusCode == 200) {
                      context.pop();
                    }
                    else if (_usernameController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              AlertDialog(
                                title: const Text('Sign Up Failed!'),
                                content: Text('Username and password required'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'))
                                ],
                              )
                      );
                    }
                    else {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: Text('Sign Up Failed!'),
                              content: Text('Username alread exist!'),
                            ),
                      );
                    }
                  });
                },
              ),
            ),
          ]
      ),
    );
  }
}