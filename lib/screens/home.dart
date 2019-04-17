import 'package:flutter/material.dart';
import 'package:study_snap/widgets/topic_list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Snap'),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: <Widget>[
            (orientation == Orientation.portrait) ? const SizedBox(height: 125) : const SizedBox(),
            Expanded(
              child: TopicList(),
            ),
            (orientation == Orientation.portrait) ? const SizedBox(height: 125) : const SizedBox(),
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
