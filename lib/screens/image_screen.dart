import 'dart:io';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/util/utils.dart';

typedef Future DeleteCallback(BuildContext context, List<int> indexes);

class ImageScreen extends StatefulWidget {
  final Topic topic;
  final List<File> images;
  final int index;
  final DeleteCallback deleteCallback;

  ImageScreen(
      {Key key, this.topic, this.images, this.index, this.deleteCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImageScreenState();
  }
}

class ImageScreenState extends State<ImageScreen> {
  int currentIndex;

  @override
  void initState() {
    setState(() {
      currentIndex = widget.index;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.topic.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                int sequence = widget.topic.indexes[currentIndex];
                File f = await getOriginalImage(widget.topic.title, sequence);
                await Share.file(
                    widget.topic.title,
                    sequence.toString() + ".jpg",
                    f.readAsBytesSync(),
                    'image/jpg');
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.deleteCallback(context,
                    <int>[widget.topic.indexes[currentIndex]]).then((val) {
                  if (val) {
                    Navigator.pop(context);
                  }
                });
              },
            )
          ],
        ),
        body: PhotoViewGallery.builder(
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(widget.images[index]),
              heroAttributes: PhotoViewHeroAttributes(
                  tag: basename(widget.images[index].path)),
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: widget.images.length,
          loadingBuilder: (context, event) => new Container(
              alignment: FractionalOffset.center,
              child: new CircularProgressIndicator()),
          pageController: PageController(initialPage: widget.index),
          onPageChanged: (newIndex) {
            setState(() {
              this.currentIndex = newIndex;
            });
          },
        ));
  }
}
