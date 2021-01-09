class ArticleUser {
  final String name;
  final String username;
  final String twitterUsername;
  final String githubUsername;
  final String website;
  final String profileImgUrl;

  ArticleUser(
      {this.name,
      this.username,
      this.twitterUsername,
      this.githubUsername,
      this.website,
      this.profileImgUrl});

  factory ArticleUser.fromJSON(Map<String, dynamic> data) {
    return ArticleUser(
        name: data["name"],
        username: data["username"],
        twitterUsername: data["twitter_username"],
        githubUsername: data["github_username"],
        profileImgUrl: data["profile_image"]);
  }
}
