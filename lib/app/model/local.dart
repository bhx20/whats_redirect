import 'dart:io';

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
