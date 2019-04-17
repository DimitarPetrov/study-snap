import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/image.dart';
import 'package:path/path.dart';
import 'package:study_snap/models/topic.dart';
import 'package:study_snap/models/topic_model.dart';

typedef void UpdateModelCallback(TopicModel model);

String stripWhitespaces(String str) {
  return str.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
}

int extractSequence(String path) {
  return int.parse(basename(path));
}

Future<List<ImageDTO>> getImages(String title) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory topicHome = new Directory(
      appDocDir.uri.resolve(stripWhitespaces(title)).path + "_th");
  return topicHome
      .list()
      .map((f) =>
          ImageDTO(image: Image.file(f), sequence: extractSequence(f.path)))
      .toList();
}

Future<File> getOriginalImage(String title, int sequence) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String imagePath = appDocDir.uri.resolve(stripWhitespaces(title)).path +
      "/" +
      sequence.toString();
  return File(imagePath);
}

void cleanUp(String title) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  new Directory(appDocDir.path + '/' + stripWhitespaces(title))
      .delete(recursive: true);
  new Directory(appDocDir.path + '/' + stripWhitespaces(title) + "_th")
      .delete(recursive: true);
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(title);
}

void deleteImage(BuildContext context, Topic topic, int index) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  deleteImageByDirectory(
      new Directory(appDocDir.path + '/' + stripWhitespaces(topic.title)),
      index);
  deleteImageByDirectory(
      new Directory(
          appDocDir.path + '/' + stripWhitespaces(topic.title) + "_th"),
      index);
  updateModel(context, (TopicModel model) => model.removeIndex(topic, index));
}

void updateModel(BuildContext context, UpdateModelCallback callback) async {
  final prefs = await SharedPreferences.getInstance();
  TopicModel model = ScopedModel.of<TopicModel>(context);
  callback(model);
  prefs.setString('topics', json.encode(model.toJson()));
}

void deleteImageByDirectory(Directory directory, int index) {
  File.fromUri(directory.uri.resolve(index.toString()))
      .deleteSync(recursive: true);
}

Future<String> getMainDirectory(Topic topic) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  return appDocDir.path + '/' + stripWhitespaces(topic.title);
}

Future<String> getThumbnailDirectory(Topic topic) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  return appDocDir.path + '/' + stripWhitespaces(topic.title) + "_th";
}

Future<int> getImageCount(Topic topic) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(topic.title) ?? 0;
}

void persistTopicsJson(String json) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('topics', json);
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
