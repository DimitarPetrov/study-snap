import 'package:json_annotation/json_annotation.dart';

part 'Topic.g.dart';

@JsonSerializable()
class Topic {

  final String title;
  final String description;

  Topic({this.title, this.description});

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);

}