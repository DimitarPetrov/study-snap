import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/models/topic_model.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/topic.dart';

class TopicList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TopicListState();
  }
}

class TopicListState extends State<TopicList> {
  List<Topic> _topics;
  ScrollController _gridController;

  @override
  void initState() {
    _gridController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TopicModel>(
      builder: (context, child, topics) {
        _topics = topics.topics;
        return ReorderableListView(
            onReorder: _onReorder,
            scrollDirection: Axis.horizontal,
            children: _topics
                .map((topic) => Dismissible(
                      key: Key(topic.title),
                      direction: DismissDirection.up,
                      confirmDismiss: (direction) {
                        _showDialog(context, topic, topics);
                      },
                      background: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.red,
                        ),
                      ),
                      child: TopicWidget(
                        topic: topic,
                        controller: _gridController,
                      ),
                    ))
                .toList());
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Topic item = _topics.removeAt(oldIndex);
      _topics.insert(newIndex, item);
    });
    persistTopicsJson(json.encode(TopicModel(topics: _topics)));
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
