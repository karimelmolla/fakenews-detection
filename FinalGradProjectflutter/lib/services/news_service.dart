import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:first_project/models/news_article.dart';

class NewsService {
  static const String _apiKey = '6401e1ce265271782bb5ec5c1d059fc6';
  static const String _baseUrl = 'https://gnews.io/api/v4';

  Future<List<NewsArticle>> fetchNews(String category) async {
    final endpoint = _getEndpointForCategory(category);

    final response =
        await http.get(Uri.parse('$_baseUrl$endpoint&token=$_apiKey&lang=en'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articles = data['articles'];
      return articles.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<NewsArticle>> fetchTopHeadlines() async {
    final response = await http.get(Uri.parse(
        'https://gnews.io/api/v4/top-headlines?category=general&apikey=6401e1ce265271782bb5ec5c1d059fc6&lang=en'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articles = data['articles'];
      return articles.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception(response.statusCode);
    }
  }

  String _getEndpointForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'politics':
        return '/top-headlines?category=politics';
      case 'entertainment':
        return '/top-headlines?category=entertainment';
      case 'sports':
        return '/top-headlines?category=sports';
      case 'health':
        return '/top-headlines?category=health';
      case 'all':
      default:
        return '/top-headlines?category=general';
    }
  }
}
