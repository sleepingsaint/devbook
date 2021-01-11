import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:devbook/models/SearchArticle.dart';
import 'package:devbook/screens/components/SearchArticleCard.dart';
import 'package:lottie/lottie.dart';

class SearchArticlesList extends StatefulWidget {
  @override
  _SearchArticlesListState createState() => _SearchArticlesListState();
}

class _SearchArticlesListState extends State<SearchArticlesList>
    with AutomaticKeepAliveClientMixin {
  String _searchInput;
  final _pageController = PagingController<int, SearchArticle>(firstPageKey: 0);
  final _searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _pageController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pageController.refresh()),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onSubmitted: (val) {
                  setState(() {
                    _searchInput = _searchController.text;
                  });
                  _pageController.refresh();
                },
                controller: _searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _searchInput = _searchController.text;
                      });
                      _pageController.refresh();
                    },
                  ),
                  hintText: "Search Articles",
                ),
              ),
            ),
            _searchInput != null
                ? Expanded(
                    child: PagedListView.separated(
                      pagingController: _pageController,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 0.0),
                      builderDelegate: PagedChildBuilderDelegate<SearchArticle>(
                        itemBuilder: (context, article, index) =>
                            SearchArticleCard(
                          article: article,
                        ),
                        noItemsFoundIndicatorBuilder: (context) => Center(
                          child: Text("No Articles Found for $_searchInput."),
                        ),
                        newPageProgressIndicatorBuilder: (context) =>
                            Lottie.asset("assets/lottie/cube.json"),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView(
                      children: [
                        Lottie.asset("assets/lottie/searching.json"),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
