import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:devbook/models/Article.dart';
import 'package:share/share.dart';
import 'package:hive/hive.dart';

class ArticleWebView extends StatefulWidget {
  final Article article;
  ArticleWebView({this.article});

  @override
  _ArticleWebViewState createState() => _ArticleWebViewState();
}

class _ArticleWebViewState extends State<ArticleWebView> {
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
              onPressed: () {
                if (isBookMarked) {
                  _bookmarkedArticlesBox.delete(this.widget.article.id);
                  setState(() {
                    this.isBookMarked = false;
                  });
                } else {
                  _bookmarkedArticlesBox.put(
                      this.widget.article.id, this.widget.article);
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
}
