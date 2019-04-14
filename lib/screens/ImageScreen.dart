import 'package:flutter/material.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/util/utils.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatefulWidget {
  final Topic topic;
  final int sequence;

  ImageScreen({Key key, this.topic, this.sequence}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImageScreenState();
  }
}

class ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
      ),
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: widget.sequence,
              child: FutureBuilder(
                future: getOriginalImage(widget.topic.title, widget.sequence),
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
              )),
        ),
      ),
    );
  }
}
