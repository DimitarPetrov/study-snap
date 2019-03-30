// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return Topic(
      title: json['title'] as String,
      description: json['description'] as String);
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description
    };
