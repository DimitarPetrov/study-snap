import 'package:flutter/material.dart';
import 'package:study_snap/models/Image.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/screens/ImageScreen.dart';
import 'package:study_snap/util/utils.dart';

class Grid extends StatelessWidget {
  final Topic topic;
  final bool clickable;

  Grid({Key key, this.topic, this.clickable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImageDTO>>(
        future: getImages(topic.title),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: new CircularProgressIndicator());
          }
          return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            children: snapshot.data.map((ImageDTO image) {
              return GridTile(
                  child:
                      clickable ? clickableTile(image, topic, snapshot.data.length, context) : image.image);
            }).toList(),
          );
        });
  }

  Widget clickableTile(ImageDTO image, Topic topic, int length, BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: image.sequence,
        child: image.image,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageScreen(
                      topic: topic,
                      length: length,
                      sequence: image.sequence,
                    )));
      },
    );
  }
}
