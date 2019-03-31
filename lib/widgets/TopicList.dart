import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/TopicModel.dart';
import 'package:study_snap/widgets/Topic.dart';

class TopicList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TopicModel>(
        builder: (context, child, topics) => ListView(
              scrollDirection: Axis.horizontal,
              children: topics.topics
                  .map((topic) => TopicWidget(
                        topic: topic,
                      ))
                  .toList(),
            ));
  }
}
