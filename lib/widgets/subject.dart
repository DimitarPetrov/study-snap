import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/screens/subject_details.dart';

class SubjectWidget extends StatelessWidget {
  final Subject subject;

  SubjectWidget({Key key, this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.subject,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(subject.title, style: Theme.of(context).textTheme.subtitle2,),
      subtitle: Text(subject.description),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SubjectDetails(
                  subject: subject,
                ),
          ),
        );
      },
    );
  }
}
