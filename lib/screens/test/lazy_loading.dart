import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class LazyLoading extends StatefulWidget {
  const LazyLoading({Key? key}) : super(key: key);

  @override
  State<LazyLoading> createState() => _LazyLoadingState();
}

class _LazyLoadingState extends State<LazyLoading> {
  final scrollController = ScrollController();
  List posts = [];
  int page = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(_scrollListerner);
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12.0),
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final title = post["title"]['rendered'];
          final description = post['link'];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(
                '$title',
                maxLines: 1,
              ),
              subtitle: Text(
                '$description',
                maxLines: 2,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> fetchPosts() async {
    final url =
        'https://techcrunch.com/wp-json/wp/v2/posts?context=embed&per_page=13&page=$page';
    print('$url');
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      setState(() {
        posts = posts + json;
      });
    } else {
      print("Unexpected response");
    }
  }

  void _scrollListerner() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      page = page + 1;
      fetchPosts();
    } else {}

    // print('scroll listerner called');
  }
}
