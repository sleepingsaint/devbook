import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

import 'package:devbook/models/Article.dart';
import 'package:devbook/screens/components/ArticleCard.dart';

class ArticlesList extends StatefulWidget {
  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  Future<List<Article>> articles;
  ScrollController _scrollController;

  int _page = 0;
  bool _showFab = false;

  _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        _showFab) {
      setState(() {
        _showFab = false;
      });
    } else if ((_scrollController.position.atEdge ||
            _scrollController.position.userScrollDirection ==
                ScrollDirection.forward) &&
        !_showFab) {
      setState(() {
        _showFab = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    articles = this._getArticles(page: this._page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder<List<Article>>(
            future: articles,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => ArticleCard(
                          article: snapshot.data[index],
                        ));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          visible: _showFab,
          child: Container(
            margin: EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(25.0)),
            // padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FlatButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.navigate_before,
                          color: this._page == 0 ? Colors.black : Colors.white,
                        ),
                        Text(
                          "Prev",
                          style: TextStyle(
                              color: this._page == 0
                                  ? Colors.black
                                  : Colors.white),
                        )
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        if (this._page != 0) {
                          this._page--;
                          this.articles = this._getArticles(page: this._page);
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FlatButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        this._page++;
                        this.articles = this._getArticles(page: this._page);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<List<Article>> _getArticles({int page = 1}) async {
    final resp = await http.get("https://dev.to/api/articles?page=$page");
    if (resp.statusCode == 200) {
      return Article.getArticles(jsonDecode(resp.body));
    } else {
      throw Exception("Failed to load articles");
    }
  }
}
