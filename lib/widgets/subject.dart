import 'package:flutter/material.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/screens/subject_details.dart';

class SubjectWidget extends StatelessWidget {
  final Subject subject;

  SubjectWidget({Key key, this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          child: ListTile(
            title: Text(subject.title),
            subtitle: Text(subject.description),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectDetails(
                      subject: subject,
                    ),
              ),
            );
          },
        ),
        Divider(),
      ],
    );
  }
}
