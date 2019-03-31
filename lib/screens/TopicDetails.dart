import 'package:flutter/material.dart';
import 'package:study_snap/models/Topic.dart';

class TopicDetails extends StatelessWidget {

  TopicDetails({Key key, this.topic}) : super(key:key);

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
    );
  }


}