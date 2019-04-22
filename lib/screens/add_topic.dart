import 'package:flutter/material.dart';
import 'package:study_snap/models/subject.dart';

import 'package:study_snap/widgets/add_topic_form.dart';

class AddTopicScreen extends StatelessWidget {

  final Subject subject;
  final ValidateCallback validate;
  final SubmitCallback handleSubmitted;
  final String title;

  AddTopicScreen({Key key, this.title,this.subject, this.validate, this.handleSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: AddTopicForm(
        subject: subject,
        validate: validate,
        handleSubmitted: handleSubmitted,
      ),
    );
  }
}
