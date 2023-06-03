// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      title: json['title'] as String,
      description: json['description'] as String,
      indexes: (json['indexes'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'indexes': instance.indexes,
    };
