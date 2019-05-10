import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/topic.dart';

class TopicList extends StatefulWidget {
  final Subject subject;

  TopicList({Key key, this.subject}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TopicListState(topics: subject.topics);
  }
}

class _TopicListState extends State<TopicList> {
  List<Topic> topics;
  ScrollController _gridController;

  _TopicListState({this.topics});

  @override
  void initState() {
    _gridController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SubjectModel>(
      builder: (context, child, model) => ReorderableListView(
          onReorder: _onReorder,
          scrollDirection: Axis.horizontal,
          children: topics
              .map((topic) => Dismissible(
                    key: Key(topic.title),
                    direction: DismissDirection.up,
                    confirmDismiss: (direction) {
                      _showDialog(topic);
                    },
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.red,
                      ),
                      child: Align(
                        alignment: FractionalOffset(0.5, 0.97),
                        child: Icon(
                          Icons.delete,
                          size: 35,
                        ),
                      ),
                    ),
                    child: TopicWidget(
                      subject: widget.subject,
                      topic: topic,
                      controller: _gridController,
                    ),
                  ))
              .toList()),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Topic item = topics.removeAt(oldIndex);
      topics.insert(newIndex, item);
    });
    updateModel(
        context,
        (model) => model
            .subjects[model.subjects.indexOf(widget.subject)].topics = topics);
  }

  void _showDialog(Topic topic) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Really delete this topic?"),
          content: new Text(
              "Be aware that this will lead to deleteion of all the images associated with "
              "this topic. If you do not have a separate copy they will be permanently lost!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                updateModel(context,
                    (model) => model.removeTopic(widget.subject, topic));
                cleanUp(topic.title);
                Navigator.pop(context);
              },
            ),
            new FlatButton(
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
