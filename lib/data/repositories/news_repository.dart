import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:news_app/core/api_constants.dart';
import 'package:news_app/data/models/cache_model.dart';
import 'package:news_app/data/models/news_model.dart';
import 'package:news_app/logic/local_storage_bloc/local_storage_bloc.dart';

class NewsRepository {
  static Future<CacheModel> getHomePageNews(
      {required String? searchTerm, required int page}) async {
    print("Function is called : searchTerm : ${searchTerm} page -> ${page}");
    try {
      
      String url = (searchTerm == null || searchTerm.trim().isEmpty)
          ? "${ApiConstants.defaultUrl}&page=$page"
          : "${ApiConstants.baseUrl}&q=$searchTerm&page=$page";

      Uri uri = Uri.parse(url);

      Response response = await http.get(uri);
      if (response.statusCode == 200) {
        int totalResults = jsonDecode(response.body)['totalResults'];

        List<dynamic> jsonData = jsonDecode(response.body)['articles'];
        List<NewsModel> newsModelList = <NewsModel>[];
        for (var item in jsonData) {
          newsModelList.add(NewsModel.fromJson(item));
        }
        CacheModel cacheModel = CacheModel(
          searchTerm: searchTerm ?? "",
          totalResults: totalResults,
          news: newsModelList,
        );
        return cacheModel;
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception({
          "message": errorBody['message'] ?? "Something went wrong",
          "code": response.statusCode
        });
      }
    } catch (e) {
      rethrow;
    }
  }
}
