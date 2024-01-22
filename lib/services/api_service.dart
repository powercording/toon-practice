import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toon/models/webtoon_detail_model.dart';
import 'package:toon/models/webtoon_episode_model.dart';
import 'package:toon/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String getToday = 'today';

  static Future<List<WebtoonModel>> getTodaysToon() async {
    final url = Uri.parse("$baseUrl/$getToday");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> webtoons = jsonDecode(response.body);

      List<WebtoonModel> webtoonModels = [];
      for (var webtoon in webtoons) {
        final webtoonModel = WebtoonModel.fromJson(webtoon);
        webtoonModels.add(webtoonModel);
      }
      return webtoonModels;
    }
    throw Exception('Failed to load data');
  }

  // static Future<List<WebtoonModel>>
  static Future<WebtoonDetailModel> getDetailById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WebtoonDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load data');
  }

  static Future<List<WebtoonEpisodeModel>> getEpisodesById(String id) async {
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> episodes = jsonDecode(response.body);

      List<WebtoonEpisodeModel> episodeModels = [];
      for (var episode in episodes) {
        final episodeModel = WebtoonEpisodeModel.fromJson(episode);
        episodeModels.add(episodeModel);
      }
      return episodeModels;
    }

    throw Exception('Failed to load data');
  }
}
