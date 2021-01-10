import 'package:devbook/screens/components/SearchArticleWebView.dart';
import 'package:flutter/material.dart';
import 'package:devbook/models/SearchArticle.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:getwidget/getwidget.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(this.article.tags != null
                        ? this.article.tags.join(", ")
                        : ""),
                  ),
                  trailing: this.article.imgUrl != null
                      ? GFAvatar(
                          backgroundImage: NetworkImage(this.article.imgUrl),
                          shape: GFAvatarShape.standard,
                        )
                      : SizedBox(),
                ),
                SizedBox(height: 5.0),
                Html(
                  data: this.article.html,
                  style: {
                    "body": Style(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      fontSize: FontSize.medium,
                    )
                  },
                )
              ],
            ),
          )),
    );
  }
}
