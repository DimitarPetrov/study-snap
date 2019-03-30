import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/models/TopicModel.dart';
import 'dart:convert';

class AddTopicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Topic'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Please enter a topic title',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Please enter a topic description',
            ),
          ),
          RaisedButton(
            onPressed: () async {
              TopicModel model = ScopedModel.of<TopicModel>(context);
              model.add(Topic(title: 'asd', description: 'asd'));
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('topics', json.encode(model.toJson()));
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
