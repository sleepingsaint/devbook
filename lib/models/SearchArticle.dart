class SearchArticle {
  final String title;
  final int id;
  final String imgUrl;
  final String html;
  final List tags;
  final String url;
  final String path;

  SearchArticle(
      {this.title,
      this.id,
      this.imgUrl,
      this.html,
      this.tags,
      this.url,
      this.path});

  factory SearchArticle.fromJSON(data) {
    return SearchArticle(
      title: data["title"],
      id: data["id"],
      tags: data["tag_list"],
      imgUrl: data["main_image"],
      html: data["highlight"] != null
          ? data["highlight"]["body_text"].join("...")
          : "",
      url: "https://dev.to${data['path']}",
      path: data["path"],
    );
  }

  static List<SearchArticle> getArticles(List<dynamic> data) {
    return data.map((e) => SearchArticle.fromJSON(e)).toList();
  }
}
