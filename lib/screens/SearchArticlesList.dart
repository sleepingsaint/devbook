import 'dart:convert';

import 'package:devbook/screens/components/SearchArticleCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:devbook/models/SearchArticle.dart';
import 'package:http/http.dart' as http;

class SearchArticlesList extends StatefulWidget {
  @override
  _SearchArticlesListState createState() => _SearchArticlesListState();
}

class _SearchArticlesListState extends State<SearchArticlesList> {
  int _page = 0;
  bool _showFab = false;

  SearchBar _searchBar;
  final _searchController = new TextEditingController();
  Future<List<SearchArticle>> _articles;
  ScrollController _scrollController;

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

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('DevBook'),
        actions: [_searchBar.getSearchAction(context)]);
  }

  @override
  void initState() {
    super.initState();
    _searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        buildDefaultAppBar: this.buildAppBar,
        controller: _searchController,
        onSubmitted: (val) {
          setState(() {
            _articles = _getSearchArticlesList(val, page: _page);
            _searchController.text = val;
          });
        });
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: _searchBar.build(context),
        body: _articles == null
            ? Center(
                child: Text("Search Articles"),
              )
            : FutureBuilder(
                future: _articles,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => SearchArticleCard(
                        article: snapshot.data[index],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("something went wrong, ${snapshot.error}"),
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          visible: _showFab,
          child: Container(
            margin: EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(25.0)),
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
                          print(_searchController.text);
                          this._articles = this._getSearchArticlesList(
                              _searchController.text,
                              page: this._page);
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
                        this._articles = this._getSearchArticlesList(
                            _searchController.text,
                            page: this._page);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<List<SearchArticle>> _getSearchArticlesList(String input,
      {int page = 0}) async {
    final resp = await http.get(
        "https://dev.to/search/feed_content?per_page=30&page=$page&search_fields=${input.split(" ").join("+")}&class_name=Article");

    if (resp.statusCode == 200) {
      return SearchArticle.getArticles(jsonDecode(resp.body)["result"]);
    } else {
      throw Exception("Search failed");
    }
  }
}
