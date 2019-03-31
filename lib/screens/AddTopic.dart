import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/models/TopicModel.dart';
import 'dart:convert';

import 'package:study_snap/widgets/AddTopicForm.dart';

class AddTopicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Topic'),
      ),
      body: AddTopicForm(),
    );
  }
}
