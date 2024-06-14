class NewsArticle {
  final String? title;
  final String? description;
  final String? content;
  final String? imageUrl;
  final String? url;

  // Add the new fields for reliability predictions
  String? prediction;
  double? reliabilityScore;
  String? sentiment;

  NewsArticle({
    this.title,
    this.description,
    this.content,
    this.imageUrl,
    this.url,
    this.prediction,
    this.reliabilityScore,
    this.sentiment,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'],
      description: json['description'],
      content: json['content'],
      imageUrl: json['image'],
      url: json['url'],
      // Initialize new fields if they are included in the JSON
      prediction: json['prediction'],
      reliabilityScore: json['reliability_score'] != null ? (json['reliability_score'] as num).toDouble() : null,
      sentiment: json['sentiment'],
    );
  }
}
