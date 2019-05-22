import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/image.dart';
import 'package:path/path.dart';
import 'package:study_snap/models/subject.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/models/subject_model.dart';

typedef void UpdateModelCallback(SubjectModel model);

String encode(String str) {
  return base64Encode(
      utf8.encode(str.replaceAll(new RegExp(r"\s+\b|\b\s"), "")));
}

int extractSequence(String path) {
  return int.parse(basename(path));
}

Future<List<ImageDTO>> getThumbnails(String title) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory topicHome =
      new Directory(appDocDir.uri.resolve(encode(title)).path + "_th");
  return topicHome
      .list()
      .map((f) =>
          ImageDTO(image: Image.file(f), sequence: extractSequence(f.path)))
      .toList();
}

Future<List<File>> getImages(String title) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory topicHome =
      new Directory(appDocDir.uri.resolve(encode(title)).path);
  return topicHome.list().map((f) => File(f.path)).toList();
}

Future<File> getOriginalImage(String title, int sequence) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String imagePath =
      appDocDir.uri.resolve(encode(title)).path + "/" + sequence.toString();
  return File(imagePath);
}

void createDirs(String title) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  new Directory(appDocDir.path + '/' + encode(title)).create(recursive: true);
  new Directory(appDocDir.path + '/' + encode(title) + "_th")
      .create(recursive: true);
}

void cleanUp(String title) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  new Directory(appDocDir.path + '/' + encode(title)).delete(recursive: true);
  new Directory(appDocDir.path + '/' + encode(title) + "_th")
      .delete(recursive: true);
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(title);
}

void deleteImage(
    BuildContext context, Subject subject, Topic topic, int index) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  deleteImageByDirectory(
      new Directory(appDocDir.path + '/' + encode(topic.title)), index);
  deleteImageByDirectory(
      new Directory(appDocDir.path + '/' + encode(topic.title) + "_th"), index);
  updateModel(context,
      (SubjectModel model) => model.removeIndex(subject, topic, index));
}

void updateModel(BuildContext context, UpdateModelCallback callback) async {
  final prefs = await SharedPreferences.getInstance();
  SubjectModel model = ScopedModel.of<SubjectModel>(context);
  callback(model);
  prefs.setString('subjects', json.encode(model.toJson()));
}

void deleteImageByDirectory(Directory directory, int index) {
  File.fromUri(directory.uri.resolve(index.toString()))
      .deleteSync(recursive: true);
}

Future<String> getMainDirectory(Topic topic) async {
  return getMainDirectoryByTitle(topic.title);
}

Future<String> getMainDirectoryByTitle(String title) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  return appDocDir.path + '/' + encode(title);
}

Future<String> getThumbnailDirectory(Topic topic) async {
  return getThumbnailDirectoryByTitle(topic.title);
}

Future<String> getThumbnailDirectoryByTitle(String title) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  return appDocDir.path + '/' + encode(title) + "_th";
}

Future<int> getImageCount(Topic topic) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(topic.title) ?? 0;
}

void renameDirs(String oldTitle, String newTitle) async {
  String mainDir = await getMainDirectoryByTitle(oldTitle);
  String thDir = await getThumbnailDirectoryByTitle(oldTitle);

  String newMainDir = await getMainDirectoryByTitle(newTitle);
  String newThDir = await getThumbnailDirectoryByTitle(newTitle);

  new Directory(mainDir).renameSync(newMainDir);
  new Directory(thDir).renameSync(newThDir);

  final prefs = await SharedPreferences.getInstance();
  int count = prefs.getInt(oldTitle);
  prefs.remove(oldTitle);
  prefs.setInt(newTitle, count);
}

void persistSubjectsJson(String json) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('subjects', json);
}

void persistTopicCount(Topic topic, int count) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt(topic.title, count);
}

Future<File> generateThumbnail(String path) async {
  ImageProperties properties =
      await FlutterNativeImage.getImageProperties(path);
  return FlutterNativeImage.compressImage(path,
      targetWidth: 500,
      targetHeight: (properties.height * 500 / properties.width).round());
}
