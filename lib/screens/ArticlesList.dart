import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;

import 'package:devbook/models/Article.dart';
import 'package:devbook/screens/components/ArticleCard.dart';

class ArticlesList extends StatefulWidget {
  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList>
    with AutomaticKeepAliveClientMixin {
  final _pageController = PagingController<int, Article>(firstPageKey: 0);

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
        child: PagedListView.separated(
          pagingController: _pageController,
          separatorBuilder: (context, index) => SizedBox(height: 4.0),
          builderDelegate: PagedChildBuilderDelegate<Article>(
            itemBuilder: (context, article, index) => ArticleCard(
              article: article,
            ),
            noItemsFoundIndicatorBuilder: (context) => Center(
              child: Text("No articles found"),
            ),
            firstPageErrorIndicatorBuilder: (context) => Center(
              child: Text("First Page Error ${_pageController.error}"),
            ),
          ),
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

  Future<List<Article>> _getArticles(int pageKey) async {
    final resp = await http.get("https://dev.to/api/articles?page=$pageKey");
    if (resp.statusCode == 200) {
      return Article.getArticles(jsonDecode(resp.body));
    }
    return [];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
