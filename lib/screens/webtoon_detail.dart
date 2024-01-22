import 'package:flutter/material.dart';
import 'package:toon/models/webtoon_model.dart';
import 'package:toon/services/api_service.dart';

class WebtoonDetailScreen extends StatelessWidget {
  final String title, thumb, id;
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
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
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
              )
            ],
          )
        ],
      ),
    );
  }
}
