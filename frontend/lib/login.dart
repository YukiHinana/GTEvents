import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

//Login Page get request and checking token and usernames
Future<String?> handleFindUsernameByTokenRequest(String token) async {
  var response = await http.get(
    Uri.parse('${Config.baseURL}/account/find'),
    headers: {"Content-Type": "application/json", "Authorization": token},
  );
  if (response.statusCode == 200) {
    return jsonDecode(utf8.decode(response.bodyBytes))['data']['username'];
  }
  return null;
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

//Login Page State controllers
class _MyLoginPageState extends State<MyLoginPage> {
  late FocusNode focusNode;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //login request variables
  Future<http.Response> sendLoginRequest() async {
    var loginData = json.encode(
        {
          'username': _usernameController.text,
          'password': _passwordController.text
        }
    );
    //if no repeated token and username, then create a new account
    var response = await http.post(
        Uri.parse('${Config.baseURL}/account/login'),
        headers: {"Content-Type": "application/json"},
        body: loginData
    );
    if (response.body.isNotEmpty) {
      final Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      final SharedPreferences prefs = await _prefs;
      if (response.statusCode == 200) {
        (prefs).setString("token", responseData['data']);
      }
    }
    return response;
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    focusNode.dispose();
  }

  //Login Page Interfaces
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Login Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              // Login and Sign up functions, save these to later sprints
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
                      labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                      hintText: 'Enter the password'
                  ),
                  controller: _passwordController,
                ),
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    Future<http.Response> re = sendLoginRequest();
                    re.then((value) {
                      // redirect to next page on success
                      if (value.statusCode == 200) {
                        var tokenVal = jsonDecode(value.body)['data'];
                        StoreProvider.of<AppState>(context).dispatch(SetTokenAction(tokenVal));
                        StoreProvider.of<AppState>(context).dispatch(SetUsernameAction(_usernameController.text));
                        context.go("/events");
                      } else {
                        // if incorrect username or password, pop alert window
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialog(
                                  title: const Text('Login Failed'),
                                  content: Text(jsonDecode(value.body)['data']),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'))
                                  ],
                                )
                        );
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                child: ElevatedButton(
                  child: const Text('SignUp'),
                  onPressed: () => context.push('/signup'),
                ),
              ),
              // SizedBox(height: 30),
              // Container(
              //   height: 400,
              //   width: double.infinity,
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //         image: AssetImage("assets/background.jpg"),
              //         fit: BoxFit.cover),
              //   ),
              // ),
            ]
        ),
      ),
    );
  }
}