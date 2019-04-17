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
  TopicDetails({Key key, this.topic, this.indexes}) : super(key: key);

  final Topic topic;
  final List<int> indexes;
  @override
  State<StatefulWidget> createState() {
    return TopicDetailsState();
  }
}

class TopicDetailsState extends State<TopicDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
      ),
      body: Grid(
        topic: widget.topic,
        clickable: true,
        indexes: widget.indexes,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showDialog(context);
        },
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Take a picture'),
                    onTap: _openCamera,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text('Select from gallery'),
                    onTap: _openGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openCamera() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    _saveImage(image);
  }

  void _openGallery() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    _saveImage(image);
  }

  void _saveImage(File image) async {
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
    TopicModel model = ScopedModel.of<TopicModel>(context);
    model.topics.singleWhere((t) => t.title == widget.topic.title).addIndex(widget.topic.title, count);
    prefs.setString('topics', json.encode(model.toJson()));
    prefs.setInt(widget.topic.title, ++count);
    setState(() {
      // just reloads grid
    });
  }
}
