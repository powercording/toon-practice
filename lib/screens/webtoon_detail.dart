import 'package:flutter/material.dart';
import 'package:toon/models/webtoon_detail_model.dart';
import 'package:toon/models/webtoon_episode_model.dart';
import 'package:toon/models/webtoon_model.dart';
import 'package:toon/services/api_service.dart';
import 'package:toon/widgets/episode.dart';

class WebtoonDetailScreen extends StatelessWidget {
  final String title, thumb, id;

  late final Future<WebtoonDetailModel> webtoonDetail =
      ApiService.getDetailById(id);
  late final Future<List<WebtoonEpisodeModel>> webtoonEpisode =
      ApiService.getEpisodesById(id);

  WebtoonDetailScreen.fromJson(WebtoonModel model, {Key? key})
      : title = model.title,
        thumb = model.thumb,
        id = model.id,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    ApiService.getDetailById(id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent.shade400,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: id,
                    child: Container(
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(2, 3),
                          )
                        ],
                      ),
                      child: Image.network(thumb),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 36,
              ),
              FutureBuilder(
                future: webtoonDetail,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text("${snapshot.data!.genre} / ${snapshot.data!.age}"),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.black,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 36,
              ),
              FutureBuilder(
                future: webtoonEpisode,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(episode: episode, webtoonId: id)
                      ],
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
