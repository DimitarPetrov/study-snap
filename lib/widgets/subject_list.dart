import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/subject.dart';

class SubjectList extends StatefulWidget {
  final List<Subject> subjects;

  SubjectList({Key? key, required this.subjects}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubjectListState(subjects: subjects);
  }
}

class _SubjectListState extends State<SubjectList> {
  List<Subject> subjects;

  _SubjectListState({required this.subjects});

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: ReorderableListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        onReorder: _onReorder,
        scrollDirection: Axis.vertical,
        children: subjects
            .map((subject) => Dismissible(
                  key: Key(subject.title),
                  direction: DismissDirection.horizontal,
                  confirmDismiss: (direction) async {
                    _showDialog(context, subject);
                  },
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      trailing: Icon(Icons.delete),
                    ),
                  ),
                  child: SubjectWidget(
                    subject: subject,
                  ),
                ))
            .toList(),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Subject item = subjects.removeAt(oldIndex);
      subjects.insert(newIndex, item);
    });
    persistSubjectsJson(json.encode(SubjectModel(subjects: subjects)));
  }

  void _showDialog(BuildContext context, Subject subject) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Really delete this subject?"),
          content: new Text(
              "Be aware that this will lead to deleteion of all the topics associated with "
              "this subject (including their images). "
              "If you do not have a separate copy they will be permanently lost!"),
          actions: <Widget>[
            new TextButton(
              child: new Text("Yes"),
              onPressed: () async {
                updateModel(context, (model) => model.remove(subject));
                for (Topic topic in subject.topics) {
                  cleanUp(topic.title);
                }
                Navigator.pop(context);
              },
            ),
            new TextButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
