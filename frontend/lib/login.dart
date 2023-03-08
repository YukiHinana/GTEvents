import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  late FocusNode focusNode;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<http.Response> sendLoginRequest() async {
    var loginData = json.encode(
        {
          'username': _usernameController.text,
          'password': _passwordController.text
        }
    );
    var response = await http.post(
        Uri.parse('http://3.145.83.83:8080/account/login'),
        headers: {"Content-Type": "application/json"},
        body: loginData
    );
    if (response.body.isNotEmpty) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final SharedPreferences prefs = await _prefs;
      if (response.statusCode == 200) {
        (prefs).setString("token", responseData['data']);
      }
    }
    return response;
  }

  Future<http.Response> sendSkipLoginRequest() async {
    var loginData = json.encode(
        {
          'username': 'bb',
          'password': '1111'
        }
    );
    var response = await http.post(
        Uri.parse('http://3.145.83.83:8080/account/login'),
        headers: {"Content-Type": "application/json"},
        body: loginData
    );
    if (response.body.isNotEmpty) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Login Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                      labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                      hintText: 'Enter the password'
                  ),
                  controller: _passwordController,
                ),
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    Future<http.Response> re = sendLoginRequest();
                    re.then((value) {
                      // redirect to next page on success
                      if (value.statusCode == 200) {
                        context.go('/posts');
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
              const SizedBox(height: 10),
              Container(
                height: 50,
                child: ElevatedButton(
                  child: const Text('Skip'),
                  onPressed: () {
                    Future<http.Response> re = sendSkipLoginRequest();
                    re.then((value) {
                      // redirect to next page on success
                      if (value.statusCode == 200) {
                        context.go('/posts');
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