import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../model/local.dart';

class StatusController extends GetxController {
  var currentIndex = 0.obs;
  int? storagePermissionCheck;
  Future<int>? permissionCheck;

  final Directory directory = Directory('/storage/emulated/0/Pictures/gbapp');

  RxList<DownloadData> downloadList = <DownloadData>[].obs;
  var isLoaded = false.obs;

  Future<int> loadPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    if (androidInfo.version.sdkInt >= 30) {
      final currentStatusManaged =
          await Permission.manageExternalStorage.status;
      if (currentStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final currentStatusStorage = await Permission.storage.status;
      if (currentStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 30) {
      final requestStatusManaged =
          await Permission.manageExternalStorage.request();
      if (requestStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final requestStatusStorage = await Permission.storage.request();
      if (requestStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> getPermissionStatus() async {
    int storagePermissionCheckInt;
    int finalPermission;

    if (storagePermissionCheck == null || storagePermissionCheck == 0) {
      storagePermissionCheck = await loadPermission();
    } else {
      storagePermissionCheck = 1;
    }
    if (storagePermissionCheck == 1) {
      storagePermissionCheckInt = 1;
    } else {
      storagePermissionCheckInt = 0;
    }

    if (storagePermissionCheckInt == 1) {
      finalPermission = 1;
    } else {
      finalPermission = 0;
    }

    return finalPermission;
  }

  @override
  void onInit() {
    super.onInit();
    setIndex();
    permissionCheck = getPermissionStatus();
    getStatusData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getStatusData() async {
    if (directory.existsSync()) {
      isLoaded(false);
      List<FileSystemEntity> files = directory.listSync();
      files.sort((a, b) => b.path.compareTo(a.path));
      downloadList.clear();
      for (var file in files) {
        if (file.path.endsWith('.jpg')) {
          downloadList.add(DownloadData(image: file.path));
        } else if (file.path.endsWith('.mp4')) {
          Uint8List? thumbnailData = await generateThumbnail(file.path);
          downloadList.add(DownloadData(
            videoPath: file.path,
            thumbnail: thumbnailData,
          ));
        }
      }
      isLoaded(true);
    }
  }

  setIndex() async {
    // int index = await PreferenceHelper.instance.getData(
    //   Pref.statusIndex,
    // );
    currentIndex(0);
  }

  Future<Uint8List?> generateThumbnail(String videoPath) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
    );
    return uint8list;
  }

  bool isWhatsApp() {
    if (!Directory(directory.path).existsSync()) {
      return false;
    } else {
      return true;
    }
  }
}
