import 'package:news_app/data/models/news_model.dart';

class CacheModel {
  final String searchTerm;
  final int totalResults;
  final List<NewsModel> news;

  CacheModel(
      {required this.searchTerm,
      required this.totalResults,
      required this.news});

  Map<String, dynamic> toJson() => {
        "searchTerm": searchTerm,
        "totalResults": totalResults,
        "news": news.map((newsItem) => newsItem.toJson()).toList(),
      };

  factory CacheModel.fromJson(Map<String, dynamic> json) => CacheModel(
        searchTerm: json["searchTerm"],
        totalResults: json["totalResults"],
        news: (json["news"] as List)
            .map((item) => NewsModel.fromJson(item))
            .toList(),
      );
}
