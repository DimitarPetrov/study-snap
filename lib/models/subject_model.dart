import 'package:scoped_model/scoped_model.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/topic.dart';

import 'package:json_annotation/json_annotation.dart';

part 'subject_model.g.dart';

@JsonSerializable()
class SubjectModel extends Model {

  final List<Subject> subjects;

  SubjectModel({required this.subjects});

  void add(Subject subject) {
    subjects.add(subject);
    notifyListeners();
  }

  void addIndex(Subject subject, Topic topic, int index) {
    subjects[subjects.indexOf(subject)].addIndex(topic,index);
    notifyListeners();
  }

  void setIndexes(Subject subject, Topic topic, List<int> indexes) {
    subjects[subjects.indexOf(subject)].setIndexes(topic, indexes);
    notifyListeners();
  }

  void removeIndex(Subject subject, Topic topic, int index) {
    subjects[subjects.indexOf(subject)].removeIndex(topic, index);
    notifyListeners();
  }

  void remove(Subject subject) {
    subjects.remove(subject);
    notifyListeners();
  }

  void addTopic(Subject subject, Topic topic) {
    subjects[subjects.indexOf(subject)].add(topic);
    notifyListeners();
  }

  void removeTopic(Subject subject, Topic topic) {
    subjects[subjects.indexOf(subject)].remove(topic);
    notifyListeners();
  }

  void sort(bool reverse) {
    subjects.sort((a,b) => reverse ? b.title.compareTo(a.title) : a.title.compareTo(b.title));
  }

  Subject? getByTitle(String title) {
    for(Subject subject in subjects) {
      if(subject.title == title) {
        return subject;
      }
    }
    return null;
  }

  Topic? getTopicByTitle(String subjectTitle, topicTitle) {
    for(Topic topic in getByTitle(subjectTitle)!.topics) {
      if(topic.title == topicTitle) {
        return topic;
      }
    }
    return null;
  }

  bool contains(String title) {
    for(Subject subject in subjects) {
      if(subject.title == title) {
        return true;
      }
    }
    return false;
  }

  factory SubjectModel.fromJson(Map<String, dynamic> json) => _$SubjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectModelToJson(this);

}