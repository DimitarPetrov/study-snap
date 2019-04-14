import 'package:flutter/material.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/util/utils.dart';

class Grid extends StatelessWidget {
  final Topic topic;

  Grid({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return FutureBuilder<List<Image>>(
        future: getImages(topic.title),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: new CircularProgressIndicator());
          }
          return GridView.count(
            crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            padding: const EdgeInsets.all(4.0),
            childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
            children: snapshot.data.map((Image image) {
              return GridTile(
                child: image,
              );
            }).toList(),
          );
        });
  }
}
