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

class TopicDetails extends StatefulWidget {
  TopicDetails({Key key, this.topic}) : super(key: key);

  final Topic topic;

  @override
  State<StatefulWidget> createState() {
    return TopicDetailsState();
  }
}

class TopicDetailsState extends State<TopicDetails> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TopicModel>(
      builder: (context, child, model) => Scaffold(
            appBar: AppBar(
              title: Text(widget.topic.title),
            ),
            body: Grid(
              topic: widget.topic,
              clickable: true,
              deleteCallback: _showDeleteDialog,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _showDialog(context, model);
              },
            ),
          ),
    );
  }

  void _showDialog(BuildContext context, TopicModel model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Take a picture'),
                    onTap: () {
                      _openCamera(model);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text('Select from gallery'),
                    onTap: () {
                      _openGallery(model);
                    },
                  ),
                ],
              ),
            ),
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
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(widget.topic.title) ?? 0;
    String path = appDocDir.path +
        '/' +
        stripWhitespaces(widget.topic.title) +
        '/' +
        count.toString();

    image.copy(path);

    String thumbnail_path = appDocDir.path +
        '/' +
        stripWhitespaces(widget.topic.title) +
        "_th"
        '/' +
        count.toString();

    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(image.path);
    File thumbnail = await FlutterNativeImage.compressImage(image.path,
        targetWidth: 500,
        targetHeight: (properties.height * 500 / properties.width).round());

    thumbnail.copy(thumbnail_path);
    model.addIndex(widget.topic, count);
    prefs.setString('topics', json.encode(model.toJson()));
    prefs.setInt(widget.topic.title, ++count);
    setState(() {
      // just reloads grid
    });
  }

  void _showDeleteDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Really delete this image?"),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Yes"),
                  onPressed: () async {
                    deleteImage(widget.topic.title, index);
                    final prefs = await SharedPreferences.getInstance();
                    TopicModel model = ScopedModel.of<TopicModel>(context);
                    model.removeIndex(widget.topic, index);
                    prefs.setString('topics', json.encode(model.toJson()));
                    Navigator.pop(context);
                  }),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
