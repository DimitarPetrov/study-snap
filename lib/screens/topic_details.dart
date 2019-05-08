import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:study_snap/models/topic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/grid.dart';
import 'package:study_snap/widgets/dialog.dart';

class TopicDetails extends StatelessWidget {
  final Subject subject;
  final Topic topic;

  TopicDetails({Key key, this.subject, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
      body: ScopedModelDescendant<SubjectModel>(
        builder: (context, child, model) => Grid(
              topic: topic,
              clickable: true,
              deleteCallback: _showDeleteDialog,
            ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showImagePickingDialog(context);
        },
      ),
    );
  }

  void _showImagePickingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TwoOptionsDialog(
            first: 'Take a picture',
            firstOnTap: () {
              _openCamera(context);
            },
            second: 'Select from gallery',
            secondOnTap: () {
              _openGallery(context);
            },
          );
        });
  }

  void _openCamera(BuildContext context) async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      _saveImage(context, image);
    }
  }

  void _openGallery(BuildContext context) async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      _saveImage(context, image);
    }
  }

  void _saveImage(BuildContext context, File image) async {
    int count = await getImageCount(topic);

    String mainDir = await getMainDirectory(topic);
    String path = mainDir + '/' + count.toString();
    image.copy(path);

    String thDir = await getThumbnailDirectory(topic);
    String thumbnailPath = thDir + '/' + count.toString();

    File thumbnail = await generateThumbnail(image.path);
    thumbnail.copy(thumbnailPath);

    await updateModel(context, (model) => model.addIndex(subject, topic, count));

    persistTopicCount(topic, ++count);
  }

  Future _showDeleteDialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Really delete this image?"),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Yes"),
                  onPressed: () async {
                    deleteImage(context, subject, topic, index);
                    Navigator.pop(context, true);
                  }),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}
