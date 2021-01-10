import 'package:devbook/models/SearchArticle.dart';
import 'package:devbook/screens/components/SearchArticleCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchArticlesList extends StatefulWidget {
  @override
  _SearchArticlesListState createState() => _SearchArticlesListState();
}

class _SearchArticlesListState extends State<SearchArticlesList> {
  SearchBar _searchBar;
  String _searchInput;
  final _pageController = PagingController<int, SearchArticle>(firstPageKey: 0);
  final _searchController = TextEditingController();

  @override
  void initState() {
    _pageController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    _searchBar = SearchBar(
      inBar: false,
      controller: _searchController,
      setState: setState,
      buildDefaultAppBar: this.buildAppBar,
      onSubmitted: (val) {
        setState(() => _searchInput = val);
        _pageController.refresh();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this._searchBar.build(context),
      body: _searchInput != null
          ? RefreshIndicator(
              onRefresh: () => Future.sync(() => _pageController.refresh()),
              child: PagedListView.separated(
                pagingController: _pageController,
                separatorBuilder: (context, index) => SizedBox(height: 0.0),
                builderDelegate: PagedChildBuilderDelegate<SearchArticle>(
                  itemBuilder: (context, article, index) => SearchArticleCard(
                    article: article,
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Text("No Articles Found"),
                  ),
                  // firstPageErrorIndicatorBuilder: (context) => ErrorInd
                  // newPageErrorIndicatorBuilder:
                ),
              ),
            )
          : Center(
              child: Text("Search Articles"),
            ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('DevBook'),
        actions: [this._searchBar.getSearchAction(context)]);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newArticles = await _getArticles(pageKey);
      final nextPageKey = pageKey + 1;
      _pageController.appendPage(newArticles, nextPageKey);
    } catch (error) {
      _pageController.error = error;
    }
  }

  Future<List<SearchArticle>> _getArticles(int pageKey) async {
    final resp = await http.get(
        "https://dev.to/search/feed_content?per_page=30&page=$pageKey&search_fields=${this._searchInput.split(" ").join("+")}&class_name=Article");
    if (resp.statusCode == 200) {
      return SearchArticle.getArticles(jsonDecode(resp.body)["result"]);
    }
    return [];
    throw Exception("Unable to retrieve articles");
  }
}
