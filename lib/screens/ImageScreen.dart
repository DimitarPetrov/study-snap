import 'package:flutter/material.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/util/utils.dart';

class ImageScreen extends StatelessWidget {
  final Topic topic;
  final int sequence;

  ImageScreen({Key key, this.topic, this.sequence}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: sequence,
              child: FutureBuilder(
                future: getOriginalImage(topic.title, sequence),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) {
                    return new Container(
                        alignment: FractionalOffset.center,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: new CircularProgressIndicator());
                  }
                  return snapshot.data;
                },
              )),
        ),
      ),
    );
  }
}
