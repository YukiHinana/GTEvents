// import 'dart:convert';
//
// import 'package:GTEvents/config.dart';
// import 'package:GTEvents/event.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class NewPostPage extends StatefulWidget {
//   const NewPostPage({super.key});
//
//   @override
//   State<NewPostPage> createState() => _NewPostPageState();
// }
//
// class _NewPostPageState extends State<NewPostPage> {
//   late TextEditingController _postTitleController;
//   late TextEditingController _postBodyController;
//   // TODO: replace with redux
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//   Post post = Post(0, "", "", "");
//
//   @override
//   void initState() {
//     super.initState();
//     _postTitleController = TextEditingController();
//     _postBodyController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _postTitleController.dispose();
//     _postBodyController.dispose();
//   }
//
//   Future<http.Response> createPostRequest() async {
//     String token = (await _prefs).get("token").toString();
//     var postData = json.encode(
//         {
//           'title': _postTitleController.text,
//           'body': _postBodyController.text
//         }
//     );
//     var response = await http.post(
//         Uri.parse('${Config.baseURL}post/create'),
//         headers: {"Content-Type": "application/json", "Authorization": token},
//         body: postData
//     );
//     return response;
//   }
//
//   Future<dynamic> getPost() async {
//     http.Response re = await createPostRequest();
//     if (re.statusCode == 200) {
//       return Post.fromJson(jsonDecode(re.body)['data']);
//     } else {
//
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Create Post'),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(13.0),
//                   child: TextField(
//                     decoration: const InputDecoration(
//                         labelText: 'Title',
//                         hintText: 'Enter the title'
//                     ),
//                     controller: _postTitleController,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(13.0),
//                   child: TextField(
//                     decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Content',
//                         hintText: 'Enter the content'
//                     ),
//                     controller: _postBodyController,
//                     maxLines: 20,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(13.0),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_postTitleController.text.isEmpty ||
//                           _postBodyController.text.isEmpty) {
//                         showDialog<String>(
//                             context: context,
//                             builder: (BuildContext context) =>
//                                 AlertDialog(
//                                   title: const Text('Error'),
//                                   content: const Text(
//                                       'Post title and content required'),
//                                   actions: [
//                                     TextButton(
//                                         onPressed: () =>
//                                             Navigator.pop(context, 'OK'),
//                                         child: const Text('OK'))
//                                   ],
//                                 )
//                         );
//                       } else {
//                         getPost().then((value) {
//                           setState(() {
//                             post = value;
//                             return context.go('/posts/view/${post.postId}');
//                           });
//                         });
//                       }
//                     },
//                     child: const Text('Post'),
//                   ),
//                 )
//               ]
//           ),
//         )
//     );
//   }
// }