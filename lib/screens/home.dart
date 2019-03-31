import 'package:flutter/material.dart';
import 'package:study_snap/widgets/TopicList.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Snap'),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 200),
            Expanded(
              child: TopicList(),
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, 'addTopic');
        },
      ),
    );
  }
}
