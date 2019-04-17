import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/routes.dart';
import 'package:study_snap/models/topic_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() async {

  final prefs = await SharedPreferences.getInstance();

  final jsonModel = prefs.getString('topics') ?? '{"topics": []}';

  final model = TopicModel.fromJson(json.decode(jsonModel));

  runApp(
      ScopedModel<TopicModel>(
        model: model,
        child: StudySnap(),
      )
  );
}
