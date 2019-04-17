import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/Image.dart';
import 'package:path/path.dart';

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

void deleteImage(String title, int index) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  deleteImageByDirectory(
      new Directory(appDocDir.path + '/' + stripWhitespaces(title)), index);
  deleteImageByDirectory(
      new Directory(appDocDir.path + '/' + stripWhitespaces(title) + "_th"),
      index);
}

void deleteImageByDirectory(Directory directory, int index) {
  File.fromUri(directory.uri.resolve(index.toString()))
      .deleteSync(recursive: true);
}
