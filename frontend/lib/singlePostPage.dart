// import 'package:flutter/material.dart';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:GTEvents/post.dart';
// import 'createPostPage.dart';
// import 'package:http/http.dart' as http;
// import 'allPostPage.dart';
//
// class SinglePostPage extends StatefulWidget {
//   final int postId;
//   const SinglePostPage({super.key, required this.postId});
//
//   @override
//   State<SinglePostPage> createState() => _SinglePostPageState();
//
// }
//
// class _SinglePostPageState extends State<SinglePostPage> {
//
//   Future<http.Response> getSinglePostRequest() async {
//     var response = await http.get(
//       Uri.parse('http://3.145.83.83:8080/post/${widget.postId}'),
//       headers: {"Content-Type": "application/json"},
//     );
//     return response;
//   }
//
//   Future<dynamic> getPost() async {
//     http.Response re = await getSinglePostRequest();
//     // print(re.body);
//     if (re.statusCode == 200) {
//       return Post.fromJson(jsonDecode(re.body)['data']);
//     } else {
//
//     }
//   }
//
//   Post post = Post(0, "", "", "");
//
//   @override
//   void initState() {
//     super.initState();
//     getPost().then((value) {
//       setState(() {
//         post = value;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Post"),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//               children: [
//                 Padding(padding: const EdgeInsets.all(13.0),
//                   child: Container(
//                       width: 600.0,
//                       height: 100.0,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(24.0),
//                         color: const Color(0xFFFF9000).withOpacity(0.8),
//                       ),
//                       child: Center(
//                         child: Text(post.title,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       )
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(13.0),
//
//                   child: Container(
//                     width: 600.0,
//                     height: 300.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(24.0),
//                       color: const Color(0xFFFF9000).withOpacity(0.5),
//                     ),
//                     child: Center(
//                       child: Text(post.body,
//                         style: const TextStyle(fontStyle: FontStyle.italic),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(13.0),
//                   child: ElevatedButton(
//                     onPressed: () => context.pop(),
//                     child: const Text('View all Posts'),
//                   ),
//                 )
//               ]
//           ),
//         )
//     );
//   }
// }