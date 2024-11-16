import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import 'post.dart';
import 'posts.dart';

class LocalStorage {
  static const String postsKey = 'posts';

  Future<void> savePosts(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(postsKey, json.encode(posts.map((post) => post.toJson()).toList()));
  }

  Future<List<Post>> loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? postsJson = prefs.getString(postsKey);
    if (postsJson != null) {
      List<dynamic> data = json.decode(postsJson);
      return data.map((post) => Post.fromJson(post)).toList();
    }
    return [];
  }
}
