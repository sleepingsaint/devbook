import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:devbook/models/Article.dart';
import 'package:devbook/screens/SearchArticlesList.dart';
import 'package:devbook/screens/ArticlesList.dart';
import 'package:devbook/screens/BookmarkedArticles.dart';
import 'package:devbook/screens/About.dart';
import 'package:devbook/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(ArticleAdapter());
  await Hive.openBox("bookmarkedArticles");
  await Hive.openBox("settings");
  runApp(DevBook());
}

class DevBook extends StatefulWidget {
  @override
  _DevBookState createState() => _DevBookState();
}

class _DevBookState extends State<DevBook> {
  int _selectedIndex = 0;
  PageController _pageController;

  static List<Widget> _screens = [
    ArticlesList(),
    SearchArticlesList(),
    BookmarkedArticles(),
    About(),
  ];

  @override
  void initState() {
    _pageController = PageController();
    theme.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: theme.currentTheme(),
      home: Scaffold(
        appBar: AppBar(title: Text("DevBook")),
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: (index) => setState(() => {_selectedIndex = index}),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Articles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Bookmarked',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Info',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
    _pageController.dispose();
    // theme.removeListener(() { })
  }
}
