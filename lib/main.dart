import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:devbook/models/Article.dart';
import 'package:devbook/screens/SearchArticlesList.dart';
import 'package:devbook/screens/ArticlesList.dart';
import 'package:devbook/screens/BookmarkedArticles.dart';
import 'package:devbook/screens/About.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(ArticleAdapter());
  await Hive.openBox("bookmarkedArticles");
  runApp(DevBook());
}

class DevBook extends StatefulWidget {
  @override
  _DevBookState createState() => _DevBookState();
}

class _DevBookState extends State<DevBook> {
  int _selectedIndex = 0;

  static List<Widget> _screens = [
    ArticlesList(),
    SearchArticlesList(),
    BookmarkedArticles(),
    About(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: _selectedIndex == 1
            ? null
            : AppBar(
                title: Text("DevBook"),
              ),
        body: _screens.elementAt(_selectedIndex),
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
          onTap: (index) => setState(() {
            _selectedIndex = index;
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }
}
