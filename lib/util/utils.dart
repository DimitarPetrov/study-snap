import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
  Directory topicHome = new Directory(appDocDir.uri.resolve(stripWhitespaces(title)).path + "_th");
  return topicHome.list().map((image) => ImageDTO(image: Image.file(image), sequence: extractSequence(image.path))).toList();
}

Future<File> getOriginalImage(String title, int sequence) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String imagePath = appDocDir.uri.resolve(stripWhitespaces(title)).path + "/" + sequence.toString();
  return File(imagePath);
}

void cleanUp(String title) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  new Directory(appDocDir.path + '/' + stripWhitespaces(title)).delete(recursive: true);
  new Directory(appDocDir.path + '/' + stripWhitespaces(title) + "_th").delete(recursive: true);
}
