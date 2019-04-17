import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/models/TopicModel.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/Topic.dart';

class TopicList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TopicModel>(
        builder: (context, child, topics) => ListView(
              scrollDirection: Axis.horizontal,
              children: topics.topics
                  .map((topic) => Dismissible(
                        key: Key(topic.title),
                        direction: DismissDirection.up,
                        confirmDismiss: (direction) {
                          _showDialog(context, topic, topics);
                        },
                        background: Container(
                          color: Colors.red,
                        ),
                        child: TopicWidget(
                          topic: topic,
                          indexes: topic.indexes,
                        ),
                      ))
                  .toList(),
            ));
  }

  void _showDialog(BuildContext context, Topic topic, TopicModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Really delete this topic?"),
          content: new Text(
              "Be aware that this will lead to deleteion of all the images associated with "
              "this topic. If you do not have a separate copy they will be permanently lost!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                model.remove(topic);
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('topics', json.encode(model.toJson()));
                cleanUp(topic.title);
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
