import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:study_snap/models/topic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_snap/screens/add_topic.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/bottom_bar.dart';
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: "Edit Topic",
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddTopicScreen(
                    title: "Edit Topic",
                    subject: subject,
                    validate: _validateEdit,
                    handleSubmitted: _handleEdit,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: ScopedModelDescendant<SubjectModel>(
        builder: (context, child, model) => Grid(
              topic: topic,
              clickable: true,
              deleteCallback: _showDeleteDialog,
            ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Photo",
        child: Icon(Icons.add_a_photo),
        onPressed: () {
          _showImagePickingDialog(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomBar(),
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

    await updateModel(
        context, (model) => model.addIndex(subject, topic, count));

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

  String _validateEdit(BuildContext context, Subject subject, String value) {
    SubjectModel model = ScopedModel.of<SubjectModel>(context);
    if (model.subjects[model.subjects.indexOf(subject)].contains(value))
      return 'Topic with this title already exists!';
    return null;
  }

  void _handleEdit(BuildContext context, Subject subject, String title,
      String description) async {
    updateModel(context, (model) {
      Subject s = model.subjects[model.subjects.indexOf(subject)];
      Topic t = s.topics[s.topics.indexOf(topic)];
      if (title.isNotEmpty) {
        String oldTitle = t.title;
        t.title = title;
        renameDirs(oldTitle, title);
      }
      if (description.isNotEmpty) {
        t.description = description;
      }
    });
    Navigator.pop(context);
  }

}
