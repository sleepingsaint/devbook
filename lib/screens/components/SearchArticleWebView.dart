import 'dart:convert';

import 'package:devbook/models/SearchArticle.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:devbook/models/Article.dart';
import 'package:share/share.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class SearchArticleWebView extends StatefulWidget {
  final SearchArticle article;
  SearchArticleWebView({this.article});

  @override
  _SearchArticleWebViewState createState() => _SearchArticleWebViewState();
}

class _SearchArticleWebViewState extends State<SearchArticleWebView> {
  bool isBookMarked = false;
  Box _bookmarkedArticlesBox = Hive.box("bookmarkedArticles");

  @override
  void initState() {
    super.initState();
    if (_bookmarkedArticlesBox.get(this.widget.article.id) != null) {
      setState(() {
        isBookMarked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.article.url),
        actions: [
          IconButton(
              icon: Icon(
                  this.isBookMarked ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () async {
                if (isBookMarked) {
                  _bookmarkedArticlesBox.delete(this.widget.article.id);
                  setState(() {
                    this.isBookMarked = false;
                  });
                } else {
                  Article article = await _getArticle(this.widget.article.id);
                  _bookmarkedArticlesBox.put(this.widget.article.id, article);
                  setState(() {
                    this.isBookMarked = true;
                  });
                }
              }),
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(this.widget.article.url,
                    subject: this.widget.article.title);
              })
        ],
      ),
      body: WebView(
        initialUrl: this.widget.article.url,
      ),
    );
  }

  Future<Article> _getArticle(int id) async {
    final resp = await http.get("https://dev.to/api/articles/$id");

    if (resp.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(resp.body);
      data["tag_list"] = data["tag_list"].split(", ");
      return Article.fromJSON(data);
    }

    throw Exception("Unable to retrive article");
  }
}
