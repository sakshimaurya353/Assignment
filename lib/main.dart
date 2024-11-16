import 'package:flutter/material.dart';

import 'screen/Post_screen.dart';
// import 'post_list_screen.dart';

void main() {
  runApp(PostTimerApp());
}

class PostTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostListScreen(),
    );
  }
}
