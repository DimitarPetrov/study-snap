import 'package:json_annotation/json_annotation.dart';
import 'package:study_snap/models/topic.dart';

part 'subject.g.dart';

@JsonSerializable()
class Subject {

  String title;
  String description;
  List<Topic> topics;

  Subject({required this.title, required this.description, required this.topics});

  void add(Topic topic) {
    topics.add(topic);
  }

  void addIndex(Topic topic, int index) {
    topics[topics.indexOf(topic)].addIndex(index);
  }

  void setIndexes(Topic topic, List<int> indexes) {
    topics[topics.indexOf(topic)].setIndexes(indexes);
  }

  void removeIndex(Topic topic, int index) {
    topics[topics.indexOf(topic)].removeIndex(index);
  }

  void remove(Topic topic) {
    topics.remove(topic);
  }

  void sort(bool reverse) {
    topics.sort((a,b) => reverse ? b.title.compareTo(a.title) : a.title.compareTo(b.title));
  }

  bool contains(String title) {
    for(Topic topic in topics) {
      if(topic.title == title) {
        return true;
      }
    }
    return false;
  }

  Topic? getByTitle(String title) {
    for(Topic topic in topics) {
      if(topic.title == title) {
        return topic;
      }
    }
    return null;
  }


  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}