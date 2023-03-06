import 'dart:convert';
import 'dart:math' as math;
import 'package:GTEvents/post.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class MyPostPage extends StatefulWidget {
  const MyPostPage({super.key});

  @override
  State<MyPostPage> createState() => _MyPostPageState();

}

class _MyPostPageState extends State<MyPostPage> {

  Future<http.Response> getAllPostRequest() async {
    var response = await http.get(
      Uri.parse('http://localhost:8080/post/'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  Future<List<Post>> getPosts() async {
    List<Post> postList = [];
    http.Response re = await getAllPostRequest();
    if (re.statusCode == 200) {
      for (var info in jsonDecode(re.body)['data'] as List<dynamic>) {
        postList.add(Post.fromJson(info));
      }
    }
    return postList;
  }

  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getPosts().then((value) {
      setState(() {
        posts = value;
      });
    });
  }

  Widget postListView() {
    Widget w = RefreshIndicator(
      onRefresh: () async {
        getPosts().then((value) {
          setState(() {
            posts = value;
          });
        });
      },
      child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 600.0,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(0.5),
              ),
              child: Column(
                children: [
                  Text("Title: ${posts[index].title}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Author: ${posts[index].author}"),
                  ElevatedButton(
                    onPressed: () {
                      return context.push('/posts/view/${posts[index].postId}');
                    },
                    child: const Text("Details"),
                  ),
                ],
              ),
            );
          }
      ),
    );
    return w;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: postListView(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(0),
        child: FloatingActionButton(
          onPressed: () => context.go('/posts/create'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}