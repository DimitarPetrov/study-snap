import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/models/TopicModel.dart';
import 'package:study_snap/util/utils.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatefulWidget {
  final Topic topic;
  final int length;
  final int sequence;
  final List<int> indexes;

  ImageScreen({Key key, this.topic, this.length, this.sequence, this.indexes})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImageScreenState(sequence: sequence);
  }
}

class ImageScreenState extends State<ImageScreen> {
  int sequence;

  ImageScreenState({this.sequence});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDialog(context, widget.topic.title, widget.sequence);
            },
          )
        ],
      ),
      body: Dismissible(
        key: Key(sequence.toString()),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            widget.indexes.indexOf(sequence) > 0  ? setState(() => sequence = widget.indexes[sequence - 1]) : setState(() {});
          } else {
            widget.indexes.indexOf(sequence) < widget.indexes.length - 1
                ? setState(() => sequence = widget.indexes[sequence + 1])
                : setState(() {});
          }
        },
        child: Center(
          child: Hero(
            tag: sequence,
            child: getImage(),
          ),
        ),
      ),
    );
  }

  Widget getImage() {
    return FutureBuilder(
      future: getOriginalImage(widget.topic.title, sequence),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Container(
              alignment: FractionalOffset.center,
              padding: const EdgeInsets.only(top: 10.0),
              child: new CircularProgressIndicator());
        }
        return PhotoView(
          imageProvider: FileImage(snapshot.data),
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
                    Navigator.pop(context, true);
                  }),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        }).then((val) {
      if (val) {
        Navigator.pop(context);
      }
    });
  }
}
