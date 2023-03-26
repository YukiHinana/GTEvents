// class Post {
//   int postId;
//   String title;
//   String author;
//   String body;
//   Post(this.postId, this.title, this.author, this.body);
//
//   factory Post.fromJson(dynamic json) {
//     return Post(json['id'] as int, json['title'] as String,
//         json['author']['username'] as String, json['body'] as String);
//   }
//
//   @override
//   String toString() {
//     return '{ $postId, $title, $author, $body }';
//   }
// }