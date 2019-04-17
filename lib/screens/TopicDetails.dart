import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_snap/models/TopicModel.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/Grid.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:study_snap/widgets/dialog.dart';

class TopicDetails extends StatelessWidget {
  TopicDetails({Key key, this.topic}) : super(key: key);

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TopicModel>(
      builder: (context, child, model) => Scaffold(
            appBar: AppBar(
              title: Text(topic.title),
            ),
            body: Grid(
              topic: topic,
              clickable: true,
              deleteCallback: _showDeleteDialog,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _showImagePickingDialog(context, model);
              },
            ),
          ),
    );
  }

  void _showImagePickingDialog(BuildContext context, TopicModel model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TwoOptionsDialog(
            first: 'Take a picture',
            firstOnTap: () {
              _openCamera(model);
            },
            second: 'Select from gallery',
            secondOnTap: () {
              _openGallery(model);
            },
          );
        });
  }

  void _openCamera(TopicModel model) async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    _saveImage(image, model);
  }

  void _openGallery(TopicModel model) async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    _saveImage(image, model);
  }

  void _saveImage(File image, TopicModel model) async {
    int count = await getImageCount(topic);

    String mainDir = await getMainDirectory(topic);
    String path = mainDir + '/' + count.toString();
    image.copy(path);

    String thDir = await getThumbnailDirectory(topic);
    String thumbnailPath = thDir + '/' + count.toString();

    File thumbnail = await generateThumbnail(image.path);
    thumbnail.copy(thumbnailPath);

    model.addIndex(topic, count);

    persistTopicsJson(json.encode(model.toJson()));
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
                    deleteImage(context, topic, index);
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
