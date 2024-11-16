import 'package:flutter/material.dart';
import 'package:posts/screen/postdetailscreen.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../posts/data_model.dart';
import '../posts/local_storage.dart';
import '../posts/posts.dart';
import '../posts/time_logic.dart';


class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ApiService _apiService = ApiService();
  final LocalStorage _localStorage = LocalStorage();

  List<Post> _posts = [];
  Map<int, PostTimer> _timers = {};
  Set<int> _readPosts = {};

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final localPosts = await _localStorage.loadPosts();
    setState(() {
      _posts = localPosts;
    });

    final apiPosts = await _apiService.fetchPosts();
    setState(() {
      _posts = apiPosts;
      _timers = {
        for (var post in apiPosts)
          post.id: PostTimer(_generateRandomDuration())
      };
    });
    _localStorage.savePosts(apiPosts);
  }

  int _generateRandomDuration() {
    return [10, 20, 25][DateTime.now().millisecondsSinceEpoch % 3];
  }

  void _updateUI() {
    setState(() {});
  }

  @override
  void dispose() {
    for (var timer in _timers.values) {
      timer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          final timer = _timers[post.id];

          return VisibilityDetector(
            key: Key(post.id.toString()),
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction > 0.5) {
                timer?.resume(_updateUI);
              } else {
                timer?.pause();
              }
            },
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  _readPosts.add(post.id);
                });
                timer?.pause();
                final detail = await _apiService.fetchPostDetail(post.id);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(post: detail),
                  ),
                );
                timer?.resume(_updateUI);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: _readPosts.contains(post.id) ? Colors.white : Colors.yellow[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(post.title)),
                    Row(
                      children: [
                        Icon(Icons.timer, color: Colors.grey),
                        SizedBox(width: 5),
                        Text('${timer?.duration ?? 0}s', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
