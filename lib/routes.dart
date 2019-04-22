import 'package:flutter/material.dart';
import 'package:study_snap/screens/home.dart';

class StudySnap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Snap',
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
      },
      theme: ThemeData.dark(),
    );
  }
}
