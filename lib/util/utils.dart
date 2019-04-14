import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';



String stripWhitespaces(String str) {
  return str.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
}

Future<List<Image>> getImages(String title) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Directory topicHome = new Directory(appDocDir.uri.resolve(stripWhitespaces(title)).path);
  return topicHome.list().map((image) => Image.file(image)).toList();
}