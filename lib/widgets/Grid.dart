import 'package:flutter/material.dart';
import 'package:study_snap/models/Image.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/screens/ImageScreen.dart';
import 'package:study_snap/util/utils.dart';

class Grid extends StatefulWidget {
  final Topic topic;
  final bool clickable;
  final DeleteCallback deleteCallback;

  Grid({Key key, this.topic, this.clickable, this.deleteCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GridState();
  }
}

class GridState extends State<Grid> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImageDTO>>(
        future: getImages(widget.topic.title),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: new CircularProgressIndicator());
          }
          snapshot.data.sort((i1, i2) => i1.sequence.compareTo(i2.sequence));
          return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            children: snapshot.data.map((ImageDTO image) {
              return GridTile(
                child: widget.clickable
                    ? _clickableTile(context, image)
                    : image.image,
              );
            }).toList(),
          );
        });
  }

  Widget _clickableTile(BuildContext context, ImageDTO image) {
    return InkWell(
      child: Hero(
        tag: image.sequence,
        child: image.image,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageScreen(
                  topic: widget.topic,
                  index: widget.topic.indexes.indexOf(image.sequence),
                  deleteCallback: widget.deleteCallback,
                ),
          ),
        );
      },
      onLongPress: () {
        widget.deleteCallback(image.sequence);
      },
    );
  }
}
