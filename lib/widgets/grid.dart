import 'dart:io';

import 'package:flutter/material.dart';
import 'package:study_snap/models/image.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/screens/image_screen.dart';
import 'package:study_snap/util/event.dart';
import 'package:study_snap/util/utils.dart';
import 'package:vocsy_esys_flutter_share/vocsy_esys_flutter_share.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';

import '../models/subject.dart';

class Grid extends StatefulWidget {
  final Subject subject;
  final Topic topic;
  final bool clickable;
  final DeleteCallback? deleteCallback;
  final ScrollController? controller;
  final Stream<Event>? stream;
  final VoidCallback? selection;

  Grid({
    Key? key,
    required this.topic,
    required this.clickable,
    this.deleteCallback,
    this.controller,
    this.stream,
    this.selection,
    required this.subject,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GridState();
  }
}

class GridState extends State<Grid> {
  late bool selecting;
  List<int> selected = List<int>.empty(growable: true);

  GridState();

  @override
  void initState() {
    selecting = false;
    if (widget.stream != null) {
      widget.stream?.listen((event) {
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
    double screenWidth = MediaQuery.of(context).size.width;
    int _crossAxisCount = 3;
    double _crossAxisSpacing = 1.5;
    double _aspectRatio = 1.0;

    var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var height = width / _aspectRatio;

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
          snapshot.data!.sort((i1, i2) => i1.sequence.compareTo(i2.sequence));
          return DragAndDropGridView(
            controller: widget.controller,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount,
              childAspectRatio: _aspectRatio,
              mainAxisSpacing: 1.5,
              crossAxisSpacing: _crossAxisSpacing,
            ),
            onWillAccept: (oldIndex, newIndex) {
              /* TODO: reorder is disabled due to two problems:
                  1) When reorder takes place and the model is updated for some reason the grid is not updated until restart -> BUG
                  2) In current design reordering is not atomic. This means that we first reorder the thumbnails and then the real images.
                     If somethings fails along the way we have inconsistent state that is impossible to be recovered or detected.
                     A mitigation for this would be to use SQLLite DB and use transactions.
                     This will require almost fully rewriting the app which can be considered for v2.
               */
              return false;
            },
            onReorder: (oldIndex, newIndex) {
              print("reorder: " + oldIndex.toString() + " -> " + newIndex.toString());
              dynamic itemToMove = snapshot.data!.removeAt(oldIndex);
              snapshot.data!.insert(newIndex, itemToMove);

              Map<int,int> newOrder = new Map();
              for (int i = 0; i < snapshot.data!.length; ++i) {
                newOrder[snapshot.data![i].sequence] = i;
              }

              reorder(widget.topic.title, newOrder).whenComplete(() {
                updateModel(context, (model) {
                  model.setIndexes(widget.subject, widget.topic, newOrder.values.toList());
                });
              });
            },
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return GridTile(
                child: widget.clickable
                    ? _clickableTile(context, snapshot.data![index])
                    : snapshot.data![index].image,
              );
            },
            isCustomFeedback: true,
            feedback: (index) {
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: snapshot.data![index].image.image,
                  ),
                ),
              );
            },
          );
        });
  }

  Widget _clickableTile(BuildContext context, ImageDTO image) {
    return Material(
      child: InkWell(
        child: Hero(
          tag: image.sequence,
          child: selecting ? _selectableImage(image) : image.image,
        ),
        onTap: () async {
          if (!selecting) {
            List<File> images = await getImages(widget.topic.title);
            images.sort((f1,f2) => extractSequence(f1.path).compareTo(extractSequence(f2.path)));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageScreen(
                  topic: widget.topic,
                  images: images,
                  index: widget.topic.indexes.indexOf(image.sequence),
                  deleteCallback: widget.deleteCallback!,
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
              widget.selection!();
            }
          });
          if (selected.contains(image.sequence)) {
            selected.remove(image.sequence);
          } else {
            selected.add(image.sequence);
          }
        },
      ),
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
                  if (value != null && value) {
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
    widget.deleteCallback!(context, selected);
  }

  void _onShare() async {
    Map<String, List<int>> data = new Map();
    for (int seq in selected) {
      String k = seq.toString() + ".jpg";
      File f = await getOriginalImage(widget.topic.title, seq);
      List<int> v = f.readAsBytesSync();
      data[k] = v;
    }
    await VocsyShare.files('images', data, 'image/jpg');
  }
}
