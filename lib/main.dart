import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize(); // prod
  // await MobileAds.instance.initialize().then((InitializationStatus status) {
  //   MobileAds.instance.updateRequestConfiguration(
  //     RequestConfiguration(testDeviceIds: <String>[
  //       '0819A79F3F94F37FBABD456D6CF92101', // this is test device id, u can view on console
  //     ]),
  //   );
  // }); // delete this code if release

  runApp(
      ScopedModel<SubjectModel>(
        model: model,
        child: StudySnap(),
      )
  );
}
