import 'package:flutter/material.dart';

import 'package:study_snap/widgets/add_topic_form.dart';

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
