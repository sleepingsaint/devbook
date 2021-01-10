import 'package:hive/hive.dart';

part 'Article.g.dart';

@HiveType(typeId: 0)
class Article {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String socialImgUrl;

  @HiveField(5)
  final List tags;

  Article(
      {this.id,
      this.title,
      this.description,
      this.url,
      this.socialImgUrl,
      this.tags});

  factory Article.fromJSON(Map<String, dynamic> data) {
    return Article(
        id: data["id"],
        title: data["title"],
        description: data["description"],
        url: data["url"],
        socialImgUrl: data["social_image"],
        tags: data["tag_list"]);
  }

  static List<Article> getArticles(List<dynamic> data) {
    return data.map((e) => Article.fromJSON(e)).toList();
  }
}
