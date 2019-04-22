import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:study_snap/screens/add_topic.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/subject_list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Study Snap"),
      ),
      body: ScopedModelDescendant<SubjectModel>(
        builder: (context, child, subjects) =>
            SubjectList(subjects: subjects.subjects),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTopicScreen(
                    title: "Add Subject",
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
    if (value.isEmpty) return 'Title of the subject can not be empty';
    SubjectModel model = ScopedModel.of<SubjectModel>(context);
    if (model.contains(value)) return 'Subject with this title already exists!';
    return null;
  }

  void _handleSubmitted(BuildContext context, Subject subject, String title,
      String description) async {
    updateModel(
        context,
        (model) => model.add(
            new Subject(title: title, description: description, topics: [])));
    Navigator.pop(context);
  }
}
