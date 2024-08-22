// To parse this JSON data, do
class NewsItem {
  final int id;
  final String date;
  final String title;
  final String excerpt;
  final String content;
  final String slug;
  final String link;
  final String thumbnail;
  final String medium;
  final String large;

  NewsItem({
    required this.id,
    required this.date,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.slug,
    required this.link,
    required this.thumbnail,
    required this.medium,
    required this.large,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      date: json['date'],
      title: json['title']['rendered'],
      excerpt: json['excerpt']['rendered'],
      content: json['content']['rendered'],
      slug: json['slug'],
      link: json['link'],
      thumbnail: json['featured_image']['thumbnail'],
      medium: json['featured_image']['medium'],
      large: json['featured_image']['large'],
    );
  }
}
