import 'dart:io';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/util/utils.dart';
import 'package:photo_view/photo_view.dart';

typedef Future DeleteCallback(BuildContext context, int index);

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
            icon: Icon(Icons.share),
            onPressed: () async {
              int sequence = widget.topic.indexes[index];
              File f = await getOriginalImage(widget.topic.title, sequence);
              await Share.file(widget.topic.title, sequence.toString() + ".jpg", f.readAsBytesSync(), 'image/jpg');
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.deleteCallback(context, widget.topic.indexes[index]).then((val) {
                if(val) {
                  Navigator.pop(context);
                }
              });
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
            child: _getImage(),
          ),
        ),
      ),
    );
  }

  Widget _getImage() {
    return FutureBuilder(
      future: getOriginalImage(widget.topic.title, widget.topic.indexes[index]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Container(
              alignment: FractionalOffset.center,
              child: new CircularProgressIndicator());
        }
        return PhotoView(
          imageProvider: FileImage(snapshot.data),
        );
      },
    );
  }
}
