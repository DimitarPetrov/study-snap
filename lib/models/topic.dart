import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic {

  String title;
  String description;
  List<int> indexes;

  Topic({required this.title, required this.description, required this.indexes});

  void addIndex(int index) {
    indexes.add(index);
    indexes.sort();
  }

  void removeIndex(int index) {
    indexes.remove(index);
  }

  void setIndexes(List<int> indexes) {
    this.indexes = indexes;
  }

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);

}