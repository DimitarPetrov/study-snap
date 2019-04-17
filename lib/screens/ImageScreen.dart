import 'package:flutter/material.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/util/utils.dart';
import 'package:photo_view/photo_view.dart';

typedef void DeleteCallback(int index);

class ImageScreen extends StatefulWidget {
  final Topic topic;
  final int index;
  final DeleteCallback deleteCallback;

  ImageScreen({Key key, this.topic, this.index, this.deleteCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImageScreenState(index: index);
  }
}

class ImageScreenState extends State<ImageScreen> {
  int index;

  ImageScreenState({this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.deleteCallback(widget.topic.indexes[index]);
            },
          )
        ],
      ),
      body: Dismissible(
        key: Key(widget.topic.indexes[index].toString()),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            index > 0 ? setState(() => index -= 1) : setState(() {});
          } else {
            index < widget.topic.indexes.length - 1
                ? setState(() => index += 1)
                : setState(() {});
          }
        },
        child: Center(
          child: Hero(
            tag: widget.topic.indexes[index],
            child: getImage(),
          ),
        ),
      ),
    );
  }

  Widget getImage() {
    return FutureBuilder(
      future: getOriginalImage(widget.topic.title, widget.topic.indexes[index]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Container(
              alignment: FractionalOffset.center,
              padding: const EdgeInsets.only(top: 10.0),
              child: new CircularProgressIndicator());
        }
        return PhotoView(
          imageProvider: FileImage(snapshot.data),
        );
      },
    );
  }
}
