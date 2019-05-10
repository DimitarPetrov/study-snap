import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/screens/add_topic.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/bottom_bar.dart';
import 'package:study_snap/widgets/topic_list.dart';

class SubjectDetails extends StatefulWidget {
  final Subject subject;

  SubjectDetails({Key key, this.subject}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SubjectDetailsState();
  }
}

class SubjectDetailsState extends State<SubjectDetails> {
  bool _reverse = false;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            tooltip: 'Sort',
            onPressed: () {
              setState(() {
                _reverse = !_reverse;
                widget.subject.sort(_reverse);
              });
            },
          )
        ],
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
                subject: widget.subject,
              ),
            ),
            (orientation == Orientation.portrait)
                ? const SizedBox(height: 75)
                : const SizedBox(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Topic",
        child: Icon(Icons.note_add),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (context) => AddTopicScreen(
                    title: "Add Topic",
                    subject: widget.subject,
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
        (model) => model.addTopic(subject,
            new Topic(title: title, description: description, indexes: [])));
    createDirs(title);
    Navigator.pop(context);
  }
}
