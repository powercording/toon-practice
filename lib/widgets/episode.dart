import 'package:flutter/material.dart';
import 'package:toon/models/webtoon_episode_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Episode extends StatelessWidget {
  final WebtoonEpisodeModel episode;
  final String webtoonId;

  const Episode({
    super.key,
    required this.episode,
    required this.webtoonId,
  });

  void onEpisodeTap() async {
    await launchUrlString(
        'https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEpisodeTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.amber.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(episode.title), const Icon(Icons.chevron_right)],
          ),
        ),
      ),
    );
  }
}
