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
            Expanded(
              child: Padding(
                  padding:
                      EdgeInsets.only(top: 200, left: 5, right: 5, bottom: 150),
                  child: TopicList()),
            ),
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
