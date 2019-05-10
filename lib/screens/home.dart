import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:study_snap/screens/add_topic.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/bottom_bar.dart';
import 'package:study_snap/widgets/subject_list.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  bool _reverse = false;
  SubjectModel _subjects;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Study Snap"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            tooltip: 'Sort',
            onPressed: () {
              setState(() {
                _reverse = !_reverse;
                _subjects.sort(_reverse);
              });
            },
          )
        ],
      ),
      body: ScopedModelDescendant<SubjectModel>(
        builder: (context, child, subjects) {
          _subjects = subjects;
          return SubjectList(subjects: subjects.subjects);
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Subject",
        child: Icon(Icons.playlist_add),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (context) => AddTopicScreen(
                    title: "Add Subject",
                    validate: _validateTitle,
                    handleSubmitted: _handleSubmitted,
                  ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomBar(),
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
