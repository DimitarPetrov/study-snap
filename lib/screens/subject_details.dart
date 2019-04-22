import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/screens/add_topic.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/topic_list.dart';

class SubjectDetails extends StatelessWidget {
  final Subject subject;

  SubjectDetails({Key key, this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text(subject.title),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: <Widget>[
            (orientation == Orientation.portrait)
                ? const SizedBox(height: 125)
                : const SizedBox(),
            Expanded(
              child: TopicList(
                subject: subject,
              ),
            ),
            (orientation == Orientation.portrait)
                ? const SizedBox(height: 125)
                : const SizedBox(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTopicScreen(
                    title: "Add Topic",
                    subject: subject,
                    validate: _validateTitle,
                    handleSubmitted: _handleSubmitted,
                  ),
            ),
          );
        },
      ),
    );
  }

  String _validateTitle(BuildContext context, Subject subject, String value) {
    if (value.isEmpty) return 'Title of the topic can not be empty';
    SubjectModel model = ScopedModel.of<SubjectModel>(context);
    if (model.subjects[model.subjects.indexOf(subject)].contains(value))
      return 'Topic with this title already exists!';
    return null;
  }

  void _handleSubmitted(BuildContext context, Subject subject, String title,
      String description) async {
    updateModel(
        context,
        (model) => model.addTopic(
            subject, new Topic(title: title, description: description, indexes: [])));
    createDirs(title);
    Navigator.pop(context);
  }
}
