import 'dart:collection';

import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/topic.dart';

import 'package:json_annotation/json_annotation.dart';

part 'topic_model.g.dart';

@JsonSerializable()
class TopicModel extends Model {

  final List<Topic> topics;

  TopicModel({this.topics});

  UnmodifiableListView<Topic> get topicsView => UnmodifiableListView(topics);

  void add(Topic topic) {
    topics.add(topic);
    notifyListeners();
  }

  void addIndex(Topic topic, int index) {
    topics[topics.indexOf(topic)].addIndex(index);
    notifyListeners();
  }

  void removeIndex(Topic topic, int index) {
    topics[topics.indexOf(topic)].removeIndex(index);
    notifyListeners();
  }

  void remove(Topic topic) {
    topics.remove(topic);
    notifyListeners();
  }

  bool contains(String title) {
    for(Topic topic in topics) {
      if(topic.title == title) {
        return true;
      }
    }
    return false;
  }

  factory TopicModel.fromJson(Map<String, dynamic> json) => _$TopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopicModelToJson(this);

}