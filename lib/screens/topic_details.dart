import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/ads/ads_factory.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:study_snap/models/topic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_snap/screens/add_topic.dart';
import 'package:study_snap/util/event.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/bottom_bar.dart';
import 'package:study_snap/widgets/grid.dart';
import 'package:study_snap/widgets/dialog.dart';

class TopicDetails extends StatefulWidget {
  final Subject subject;
  final Topic topic;

  TopicDetails({Key? key, required this.subject, required this.topic}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TopicDetailsState();
  }
}

class TopicDetailsState extends State<TopicDetails> {
  bool selecting = false;
  StreamController<Event> _controller = StreamController<Event>();
  late BannerAd _bannerAd;

  @override
  void initState() {
    _bannerAd = BannerAdsFactory.createBannerAd()..load();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        leading: selecting
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    selecting = !selecting;
                    _controller.add(Event.SELECTING);
                  });
                },
              )
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: "Delete",
            onPressed: () {
              setState(() {
                if (!selecting) {
                  setState(() {
                    selecting = !selecting;
                  });
                }
                _controller.add(Event.DELETE);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            tooltip: "Share",
            onPressed: () {
              setState(() {
                if (!selecting) {
                  setState(() {
                    selecting = !selecting;
                  });
                }
                _controller.add(Event.SHARE);
              });
            },
          ),
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
                    subject: widget.subject,
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
            subject: widget.subject,
            topic: widget.topic,
            clickable: true,
            deleteCallback: _showDeleteDialog,
            stream: _controller.stream,
            selection: () {
              setState(() {
                selecting = !selecting;
              });
            }),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Photo",
        child: Icon(Icons.add_a_photo),
        onPressed: () {
          _showImagePickingDialog(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomBar(bannerAd: _bannerAd,),
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
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      await _saveImage(context, image);
    }
  }

  void _openGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      for (XFile image in images) {
        await _saveImage(context, image);
      }
    }
  }

  Future<void> _saveImage(BuildContext context, XFile image) async {
    int count = await getImageCount(widget.topic);

    String mainDir = await getMainDirectory(widget.topic);
    String path = mainDir + '/' + count.toString();
    image.saveTo(path);

    String thDir = await getThumbnailDirectory(widget.topic);
    String thumbnailPath = thDir + '/' + count.toString();

    File thumbnail = await generateThumbnail(image.path);
    thumbnail.copy(thumbnailPath);

    await updateModel(context,
        (model) => model.addIndex(widget.subject, widget.topic, count));

    persistTopicCount(widget.topic, ++count);
  }

  Future _showDeleteDialog(BuildContext context, List<int> indexes) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Really delete images?"),
            actions: <Widget>[
              new TextButton(
                  child: new Text("Yes"),
                  onPressed: () async {
                    for (int index in indexes) {
                      deleteImage(context, widget.subject, widget.topic, index);
                    }
                    Navigator.pop(context, true);
                  }),
              new TextButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }

  String? _validateEdit(BuildContext context, Subject? subject, String? value) {
    SubjectModel model = ScopedModel.of<SubjectModel>(context);
    if (value == null || value.isEmpty) return "Title of the topic can not be empty";
    if (model.subjects[model.subjects.indexOf(subject!)].contains(value))
      return 'Topic with this title already exists!';
    return null;
  }

  void _handleEdit(BuildContext context, Subject subject, String title,
      String description) async {
    updateModel(context, (model) {
      Subject s = model.subjects[model.subjects.indexOf(subject)];
      Topic t = s.topics[s.topics.indexOf(widget.topic)];
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
