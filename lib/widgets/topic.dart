import 'package:flutter/material.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/screens/topic_details.dart';
import 'package:study_snap/widgets/grid.dart';

class TopicWidget extends StatelessWidget {
  final Topic topic;

  TopicWidget({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopicDetails(topic: topic),
              ),
            );
          },
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  topic.title,
                  style: Theme.of(context).textTheme.body1,
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 7.5),
                  child: Text(
                    topic.description,
                    style: Theme.of(context).textTheme.overline,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: Grid(
                  topic: topic,
                  clickable : false,
                ),
              ),
            ],
          ),
        ),
        color: Theme.of(context).cardColor,
      ),
    );
  }
}
