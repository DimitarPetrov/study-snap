import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/Image.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/models/TopicModel.dart';
import 'package:study_snap/screens/ImageScreen.dart';
import 'package:study_snap/util/utils.dart';

class Grid extends StatefulWidget {
  final Topic topic;
  final bool clickable;
  final List<int> indexes;

  Grid({Key key, this.topic, this.clickable, this.indexes}) : super(key: key);

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
          return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            children: snapshot.data.map((ImageDTO image) {
              return GridTile(
                child: widget.clickable
                    ? _clickableTile(
                        image, widget.topic, snapshot.data.length, context)
                    : image.image,
              );
            }).toList(),
          );
        });
  }

  Widget _clickableTile(
      ImageDTO image, Topic topic, int length, BuildContext context) {
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
                  length: length,
                  sequence: image.sequence,
                  indexes: widget.indexes,
                ),
          ),
        );
      },
      onLongPress: () {
        _showDialog(
          context,
          topic.title,
          image.sequence,
        );
      },
    );
  }

  void _showDialog(BuildContext context, String title, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Really delete this image?"),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Yes"),
                  onPressed: () async {
                    deleteImage(title, index);
                    final prefs = await SharedPreferences.getInstance();
                    TopicModel model = ScopedModel.of<TopicModel>(context);
                    print(json.encode(model.toJson()));
                    model.topics.singleWhere((t) => t.title == widget.topic.title).removeIndex(widget.topic.title, index);
                    prefs.setString('topics', json.encode(model.toJson()));
                    Navigator.pop(context);
                  }),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }).then((val) {
          setState(() {

          });
    });
  }
}
