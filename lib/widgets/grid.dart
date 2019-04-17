import 'package:flutter/material.dart';
import 'package:study_snap/models/image.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/screens/image_screen.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/dialog.dart';

class Grid extends StatelessWidget {
  final Topic topic;
  final bool clickable;
  final DeleteCallback deleteCallback;

  Grid({Key key, this.topic, this.clickable, this.deleteCallback})
      : super(key: key);

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
          snapshot.data.sort((i1, i2) => i1.sequence.compareTo(i2.sequence));
          return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            children: snapshot.data.map((ImageDTO image) {
              return GridTile(
                child: clickable
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
                  topic: topic,
                  index: topic.indexes.indexOf(image.sequence),
                  deleteCallback: deleteCallback,
                ),
          ),
        );
      },
      onLongPress: () {
        _showDialog(context, image);
      },
    );
  }

  void _showDialog(BuildContext context, ImageDTO image) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TwoOptionsDialog(
            first: 'Delete',
            firstOnTap: () {
              deleteCallback(context, image.sequence).then((val) {
                if (val) {
                  Navigator.pop(context);
                }
              });
            },
            second: 'Share',
            secondOnTap: () {
              //TODO
            },
          );
        });
  }

}
