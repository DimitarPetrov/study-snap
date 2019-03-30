import 'package:flutter/material.dart';

class Topic extends StatelessWidget {
  final String title;
  final String description;

  Topic({Key key, this.title, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 175,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  title,
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  description,
                  style: Theme.of(context).textTheme.overline,
                ),
              )
            ],
          ),
          color: Theme.of(context).cardColor,
        ));
  }
}
