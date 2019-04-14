import 'package:flutter/material.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:study_snap/screens/TopicDetails.dart';
import 'package:study_snap/util/utils.dart';

class TopicWidget extends StatefulWidget {
  final Topic topic;

  TopicWidget({Key key, this.topic}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TopicWidgetState();
  }
}

class TopicWidgetState extends State<TopicWidget> {
  List<Image> _images = <Image>[];

  @override
  void initState() {
    super.initState();
    _getImages();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      width: 175,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: InkWell(
          onTap: () {
            _navigate(context);
          },
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  widget.topic.title,
                  style: Theme.of(context).textTheme.body1,
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 7.5),
                  child: Text(
                    widget.topic.description,
                    style: Theme.of(context).textTheme.overline,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: GridView.count(
                  crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                  childAspectRatio:
                      (orientation == Orientation.portrait) ? 1.0 : 1.3,
                  children: _images,
                ),
              ),
            ],
          ),
        ),
        color: Theme.of(context).cardColor,
      ),
    );
  }

  void _navigate(BuildContext context) async {
    List<Image> images = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicDetails(topic: widget.topic),
      ),
    );
    setState(() {
      _images = images;
    });
  }

  void _getImages() async {
    List<Image> images = await getImages(widget.topic.title);
    setState(() {
      _images = images;
    });
  }
}
