import 'package:devbook/screens/components/ArticleCard.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarkedArticles extends StatefulWidget {
  @override
  _BookmarkedArticlesState createState() => _BookmarkedArticlesState();
}

class _BookmarkedArticlesState extends State<BookmarkedArticles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: Hive.box("bookmarkedArticles").listenable(),
        builder: (context, box, _) => box.length > 0
            ? ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) => ArticleCard(
                      article: box.getAt(index),
                    ))
            : Center(child: Text("No articles bookmarked")),
      ),
    );
  }
}
