import 'package:flutter/material.dart';
import 'package:study_snap/models/Topic.dart';

class ImageScreen extends StatelessWidget {
  final Topic topic;
  final Image image;

  ImageScreen({Key key, this.topic, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
      body: GestureDetector(
        child: Center(
          child: Hero(tag: image.toString(), child: image),
        ),
      ),
    );
  }
}
