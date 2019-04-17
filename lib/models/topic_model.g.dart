// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) {
  return TopicModel(
      topics: (json['topics'] as List)
          ?.map((e) =>
              e == null ? null : Topic.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$TopicModelToJson(TopicModel instance) =>
    <String, dynamic>{'topics': instance.topics};
