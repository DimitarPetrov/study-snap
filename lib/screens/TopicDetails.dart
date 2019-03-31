import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:image_picker/image_picker.dart';

class TopicDetails extends StatefulWidget {

  TopicDetails({Key key, this.topic}) : super(key: key);

  final Topic topic;

  @override
  State<StatefulWidget> createState() {
    return TopicDetailsState();
  }

}

class TopicDetailsState extends State<TopicDetails>{

  List<Image> _images = <Image>[];

  @override
  void initState() {
    super.initState();
    _getImages();
  }


  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
      ),
      body: GridView.count(
        crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        padding: const EdgeInsets.all(4.0),
        childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
        children: _images,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        GestureDetector(
                          child: new Text('Take a picture'),
                          onTap: openCamera,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        GestureDetector(
                          child: new Text('Select from gallery'),
                          onTap: openGallery,
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  void _getImages() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory topicHome = new Directory(appDocDir.uri.resolve(widget.topic.title).path);
    List<Image> images = topicHome.listSync().map((image) => Image.file(image)).toList();
    setState((){
      _images = images;
    });
  }

  void openCamera() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    print(image.path);
    saveImage(image);
  }

  void openGallery() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    saveImage(image);
  }

  void saveImage(File image) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(widget.topic.title) ?? 0;
    String path =
        appDocDir.path + '/' + widget.topic.title + '/' + count.toString();
    print(path);
    image.copy(path);
    prefs.setInt(widget.topic.title, ++count);
    _getImages();
  }
}
