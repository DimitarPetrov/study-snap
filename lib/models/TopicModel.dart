import 'dart:collection';

import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/Topic.dart';

import 'package:json_annotation/json_annotation.dart';

part 'TopicModel.g.dart';

@JsonSerializable()
class TopicModel extends Model {

  final List<Topic> topics;

  TopicModel({this.topics});

  UnmodifiableListView<Topic> get topicsView => UnmodifiableListView(topics);

  void add(Topic topic) {
    topics.add(topic);
    notifyListeners();
  }

  void remove(Topic topic) {
    topics.remove(topic);
    notifyListeners();
  }

  factory TopicModel.fromJson(Map<String, dynamic> json) => _$TopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopicModelToJson(this);

}