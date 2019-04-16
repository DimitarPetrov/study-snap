import 'package:flutter/material.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/util/utils.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatefulWidget {
  final Topic topic;
  final int length;
  final int sequence;

  ImageScreen({Key key, this.topic, this.length, this.sequence})
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
      ),
      body: Dismissible(
        key: Key(sequence.toString()),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            sequence > 0
                ? setState(() => sequence -= 1)
                : setState(() {});
          } else {
            sequence < widget.length - 1
                ? setState(() => sequence += 1)
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
}
