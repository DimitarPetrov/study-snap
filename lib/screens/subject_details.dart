import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/ads/ads_factory.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/subject_model.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/screens/add_topic.dart';
import 'package:study_snap/screens/topic_details.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/bottom_bar.dart';
import 'package:study_snap/widgets/search_delegate.dart';
import 'package:study_snap/widgets/topic_list.dart';

class SubjectDetails extends StatefulWidget {
  final Subject subject;

  SubjectDetails({Key? key, required this.subject}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SubjectDetailsState();
  }
}

class SubjectDetailsState extends State<SubjectDetails> {
  bool _reverse = false;
  late SearchTitleDelegate _searchDelegate;
  late BannerAd _bannerAd;

  @override
  void initState() {
    _bannerAd = BannerAdsFactory.createBannerAd()..load();
    List<String> titles = widget.subject.topics.map((t) => t.title).toList();
    _searchDelegate =
        SearchTitleDelegate(words: titles, onSelectCallback: _onSelectCallback);
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.title),
        actions: <Widget>[
          IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () async {
                showSearchPage(context, _searchDelegate);
              }),
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddTopicScreen(
                        title: "Edit Subject",
                        subject: widget.subject,
                        validate: _validateEdit,
                        handleSubmitted: _handleEdit,
                      ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            tooltip: 'Sort',
            onPressed: () {
              setState(() {
                _reverse = !_reverse;
                widget.subject.sort(_reverse);
              });
              updateModel(context, (model) {
                model.subjects[model.subjects.indexOf(widget.subject)]
                    .sort(_reverse);
              });
            },
          )
        ],
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: <Widget>[
            (orientation == Orientation.portrait)
                ? const SizedBox(height: 125)
                : const SizedBox(),
            Expanded(
              child: TopicList(
                subject: widget.subject,
              ),
            ),
            (orientation == Orientation.portrait)
                ? const SizedBox(height: 75)
                : const SizedBox(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Topic",
        child: Icon(Icons.library_add),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (context) => AddTopicScreen(
                    title: "Add Topic",
                    subject: widget.subject,
                    validate: _validateTitle,
                    handleSubmitted: _handleSubmitted,
                  ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomBar(bannerAd: _bannerAd),
    );
  }

  void _onSelectCallback(String query) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicDetails(
            subject: widget.subject, topic: widget.subject.getByTitle(query)!),
      ),
    );
    Navigator.pop(context);
  }

  Future showSearchPage(
      BuildContext context, SearchTitleDelegate searchDelegate) async {
    await showSearch<String?>(
      context: context,
      delegate: searchDelegate,
    );
  }

  String? _validateEdit(BuildContext context, Subject? subject, String? value) {
    SubjectModel model = ScopedModel.of<SubjectModel>(context);
    if (value == null || value.isEmpty) return 'Title of the subject can not be empty';
    if (model.contains(value)) return 'Subject with this title already exists!';
    return null;
  }

  void _handleEdit(BuildContext context, Subject? subject, String title,
      String description) async {
    updateModel(context, (model) {
      Subject s = model.subjects[model.subjects.indexOf(subject!)];
      if (title.isNotEmpty) {
        s.title = title;
      }
      if (description.isNotEmpty) {
        s.description = description;
      }
    });
    Navigator.pop(context);
  }

  String? _validateTitle(BuildContext context, Subject? subject, String? value) {
    if (value == null || value.isEmpty) return 'Title of the topic can not be empty';
    SubjectModel model = ScopedModel.of<SubjectModel>(context);
    if (model.subjects[model.subjects.indexOf(subject!)].contains(value))
      return 'Topic with this title already exists!';
    return null;
  }

  void _handleSubmitted(BuildContext context, Subject? subject, String title,
      String description) async {
    updateModel(
        context,
        (model) => model.addTopic(subject!,
            new Topic(title: title, description: description, indexes: [])));
    createDirs(title);
    Navigator.pop(context);
  }
}
