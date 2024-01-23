import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toon/models/webtoon_detail_model.dart';
import 'package:toon/models/webtoon_episode_model.dart';
import 'package:toon/models/webtoon_model.dart';
import 'package:toon/services/api_service.dart';
import 'package:toon/widgets/episode.dart';

class WebtoonDetailScreen extends StatefulWidget {
  final String title, thumb, id;

  WebtoonDetailScreen.fromJson(WebtoonModel model, {Key? key})
      : title = model.title,
        thumb = model.thumb,
        id = model.id,
        super(key: key);

  @override
  State<WebtoonDetailScreen> createState() => _WebtoonDetailScreenState();
}

class _WebtoonDetailScreenState extends State<WebtoonDetailScreen> {
  late bool isFavorite = false;
  late final SharedPreferences preferences;

  late final Future<WebtoonDetailModel> webtoonDetail =
      ApiService.getDetailById(widget.id);

  late final Future<List<WebtoonEpisodeModel>> webtoonEpisode =
      ApiService.getEpisodesById(widget.id);

  Future getPreference() async {
    preferences = await SharedPreferences.getInstance();
    final favoriteList = preferences.getStringList("favoriteList");

    if (favoriteList != null) {
      if (favoriteList.contains(widget.id)) {
        setState(() {
          isFavorite = true;
        });
      }
    } else {
      preferences.setStringList('favoriteList', []);
    }
  }

  void toggleFavorite() async {
    final favoriteList = preferences.getStringList("favoriteList");
    if (favoriteList != null) {
      if (!isFavorite) {
        favoriteList.add(widget.id);
      } else {
        favoriteList.remove(widget.id);
      }
      await preferences.setStringList('favoriteList', favoriteList);
    }

    setState(() {
      isFavorite = favoriteList!.contains(widget.id);
    });
  }

  @override
  void initState() {
    getPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ApiService.getDetailById(widget.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent.shade400,
        actions: [
          IconButton(
            onPressed: toggleFavorite,
            icon: isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
          )
        ],
        title: Text(
          widget.title,
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
                    tag: widget.id,
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
                      child: Image.network(widget.thumb),
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
                          Episode(episode: episode, webtoonId: widget.id)
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
