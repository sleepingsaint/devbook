import 'package:devbook/screens/components/SearchArticleWebView.dart';
import 'package:flutter/material.dart';
import 'package:devbook/models/SearchArticle.dart';
import 'package:flutter_html/flutter_html.dart';

class SearchArticleCard extends StatelessWidget {
  final SearchArticle article;

  SearchArticleCard({this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchArticleWebView(
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
              this.article.imgUrl != null
                  ? Image.network(this.article.imgUrl)
                  : SizedBox(),
              Html(data: this.article.html)
            ],
          )),
    );
  }
}
