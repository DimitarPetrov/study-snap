import 'dart:io';

import 'package:flutter/material.dart';
import 'package:study_snap/models/image.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/screens/image_screen.dart';
import 'package:study_snap/util/event.dart';
import 'package:study_snap/util/utils.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class Grid extends StatefulWidget {
  final Topic topic;
  final bool clickable;
  final DeleteCallback deleteCallback;
  final ScrollController controller;
  final Stream<Event> stream;
  final VoidCallback selection;

  Grid({
    Key key,
    this.topic,
    this.clickable,
    this.deleteCallback,
    this.controller,
    this.stream,
    this.selection,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GridState();
  }
}

class GridState extends State<Grid> {
  bool selecting;
  List<int> selected = List<int>();

  GridState({this.selecting});

  @override
  void initState() {
    selecting = false;
    if (widget.stream != null) {
      widget.stream.listen((event) {
        if (event == Event.DELETE) {
          if (selecting) {
            if (selected.isNotEmpty) _onDelete();
          } else {
            setState(() {
              selecting = !selecting;
            });
          }
        } else if (event == Event.SHARE) {
          if (selecting) {
            if (selected.isNotEmpty) _onShare();
          } else {
            setState(() {
              selecting = !selecting;
            });
          }
        } else if (event == Event.SELECTING) {
          setState(() {
            selecting = !selecting;
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!selecting) {
      selected.clear();
    }
    return FutureBuilder<List<ImageDTO>>(
        future: getThumbnails(widget.topic.title),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: new CircularProgressIndicator());
          }
          snapshot.data.sort((i1, i2) => i1.sequence.compareTo(i2.sequence));
          return GridView.count(
            controller: widget.controller,
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            children: snapshot.data.map((ImageDTO image) {
              return GridTile(
                child: widget.clickable
                    ? _clickableTile(context, image)
                    : image.image,
              );
            }).toList(),
          );
        });
  }

  Widget _clickableTile(BuildContext context, ImageDTO image) {
    return InkWell(
      child: Hero(
        tag: image.sequence,
        child: selecting ? _selectableImage(image) : image.image,
      ),
      onTap: () async {
        if (!selecting) {
          List<File> images = await getImages(widget.topic.title);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageScreen(
                    topic: widget.topic,
                    images: images,
                    index: widget.topic.indexes.indexOf(image.sequence),
                    deleteCallback: widget.deleteCallback,
                  ),
            ),
          );
        } else {
          setState(() {
            if (selected.contains(image.sequence)) {
              selected.remove(image.sequence);
            } else {
              selected.add(image.sequence);
            }
          });
        }
      },
      onLongPress: () async {
        setState(() {
          if (!selecting) {
            selecting = !selecting;
            widget.selection();
          }
        });
        if (selected.contains(image.sequence)) {
          selected.remove(image.sequence);
        } else {
          selected.add(image.sequence);
        }
      },
    );
  }

  Widget _selectableImage(ImageDTO image) {
    return Center(
      child: Stack(
        children: <Widget>[
          image.image,
          Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.black,
            ),
            child: Checkbox(
              checkColor: Colors.black,
              value: selected.contains(image.sequence),
              onChanged: (value) {
                setState(() {
                  if (value) {
                    selected.add(image.sequence);
                  } else {
                    selected.remove(image.sequence);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onDelete() {
    widget.deleteCallback(context, selected);
  }

  void _onShare() async {
    Map<String, List<int>> data = new Map();
    for (int seq in selected) {
      String k = seq.toString() + ".jpg";
      File f = await getOriginalImage(widget.topic.title, seq);
      List<int> v = f.readAsBytesSync();
      data[k] = v;
    }
    await Share.files('images', data, 'image/jpg');
  }
}
