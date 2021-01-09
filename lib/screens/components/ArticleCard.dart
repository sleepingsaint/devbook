import 'package:flutter/material.dart';
import 'package:devbook/models/Article.dart';
import 'package:devbook/screens/components/ArticleWebView.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  ArticleCard({this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ArticleWebView(
                  article: this.article,
                )));
      },
      child: Card(
          margin: EdgeInsets.all(5.0),
          elevation: 5.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  this.article.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Image.network(this.article.socialImgUrl),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  this.article.description,
                  style: Theme.of(context).textTheme.caption,
                ),
              )
            ],
          )),
    );
  }
}
