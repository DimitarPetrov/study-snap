import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/routes.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final jsonModel = prefs.getString('subjects') ?? '{"subjects": []}';

  final model = SubjectModel.fromJson(json.decode(jsonModel));

  FirebaseAdMob.instance.initialize(appId: "ca-app-pub-8543805483173927~1931251623", analyticsEnabled: true);

  runApp(
      ScopedModel<SubjectModel>(
        model: model,
        child: StudySnap(),
      )
  );
}
