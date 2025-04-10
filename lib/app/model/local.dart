import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DownloadData {
  final String? image;
  final String? videoPath;
  final Uint8List? thumbnail;
  DownloadData({this.image, this.videoPath, this.thumbnail});
}

class MediaType {
  final File file;
  final bool isVideo;
  MediaType({required this.file, required this.isVideo});
}

class MoreItem {
  final IconData icon;
  final String title;
  MoreItem({required this.icon, required this.title});
}

class NumberData {
  final String number;
  final String origin;
  final String code;

  NumberData({required this.number, required this.origin, required this.code});
}
