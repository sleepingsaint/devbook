import 'package:flutter/material.dart';
import 'package:devbook/models/Article.dart';
import 'package:devbook/screens/components/ArticleWebView.dart';
import 'package:getwidget/getwidget.dart';

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
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    this.article.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(this.article.tags != null
                        ? "# ${this.article.tags.join(", ")}"
                        : ""),
                  ),
                  trailing: GFAvatar(
                    backgroundImage: NetworkImage(this.article.socialImgUrl),
                    shape: GFAvatarShape.standard,
                  ),
                ),
                Text(
                  this.article.description,
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          )),
    );
  }
}
