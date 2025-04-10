import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../model/local.dart';
import '../reusable/globle.dart';
import '../view/saver/widgets/open_image_dialog.dart';
import '../view/saver/widgets/open_video_dialog.dart';

class StatusController extends GetxController {
  var currentIndex = 0.obs;
  int? storagePermissionCheck;
  Future<int>? permissionCheck;
  final Directory directory = Directory(
      '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
  RxList<MediaType> mediaList = <MediaType>[].obs;
  RxInt selectedCategory = 0.obs;
  List<String> filterList = ["All", "Images", "Videos"];

  RxList<DownloadData> downloadList = <DownloadData>[].obs;
  var isLoaded = false.obs;

  List<MoreItem> items = [
    MoreItem(
      icon: Icons.report,
      title: "Report",
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    permissionCheck = getPermissionStatus();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  reportStatus() async {
    String phoneNumber = "+919727409439";
    String appName = "What's Redirect";
    String issue = "Describe your issue here...";
    String deviceInfo = "Android";
    String dateTime = DateFormat('HH:mm a (dd/MM/yyyy)').format(DateTime.now());

    // Formatting the WhatsApp message
    String message = """
📢 *Report Issue - $appName*    
📅 *Date:* $dateTime  
📱 *Device:* $deviceInfo  

✍ *Issue:*  
$issue
  """;

    String androidUrl =
        "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}";

    try {
      await launchUrl(Uri.parse(androidUrl));
    } catch (e) {
      showToast("We are not able to send the report.");
    }
  }

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

  getStatusData() {
    if (Directory(directory.path).existsSync()) {
      isLoaded(false);
      mediaList.value = directory
          .listSync()
          .where((item) => _isValidMedia(item.path))
          .map((item) => MediaType(
                file: File(item.path),
                isVideo: _isVideo(item.path),
              ))
          .toList(growable: false)
        ..sort((a, b) => b.file.path.compareTo(a.file.path));

      isLoaded(true);
      update();
    }
  }

  void help() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: "coddynet@gmail.com",
    );
    urlLauncher(params);
  }

  Future<void> urlLauncher(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  List<MediaType> get filteredMediaList {
    if (selectedCategory.value == 0) {
      return mediaList;
    } else if (selectedCategory.value == 1) {
      return mediaList.where((item) => !item.isVideo).toList();
    } else {
      return mediaList.where((item) => item.isVideo).toList();
    }
  }

  void updateFilter(int category) {
    selectedCategory.value = category;
    update();
  }

  bool _isValidMedia(String path) {
    final extension = path.split('.').last.toLowerCase();
    return ['jpg'].contains(extension) || ['mp4'].contains(extension);
  }

  bool _isVideo(String path) {
    final extension = path.split('.').last.toLowerCase();
    return ['mp4'].contains(extension);
  }

  void openMedia(BuildContext context, File file, bool isVideo) {
    if (isVideo) {
      openVideo(context, file);
    } else {
      openImage(context, file.path);
    }
  }

  downloadImage(String imgPath) async {
    Get.back();
    await Gal.putImage(imgPath);
    showToast("Image Downloaded Successfully");
  }

  downloadVideo(File file) async {
    Get.back();
    await Gal.putVideo(file.path);

    showToast("Video Downloaded Successfully");
  }

  bool isWhatsApp() {
    return Directory(directory.path).existsSync();
  }

  Future<File?> generateThumbnail(File videoFile) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoFile.path,
      thumbnailPath: (await Directory.systemTemp.createTemp()).path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 1280,
      quality: 75,
    );
    return thumbnail != null ? File(thumbnail) : null;
  }

  void shareImage(String imgPath, String text) async {
    if (imgPath.isNotEmpty) {
      final file = File(imgPath);
      if (await file.exists()) {
        final directory = await getTemporaryDirectory();
        final imageFileName = imgPath.split('/').last;
        final newImagePath = '${directory.path}/$imageFileName';
        await file.copy(newImagePath);
        Get.back();
        Share.shareXFiles([XFile(newImagePath)], text: text);
      } else {
        showToast("Image file not found");
      }
    } else {
      showToast("Image path is null or empty");
    }
  }

  void shareVideo(String videoPath, String text) async {
    if (videoPath.isNotEmpty) {
      final file = File(videoPath);
      if (await file.exists()) {
        final directory = await getTemporaryDirectory();
        final imageFileName = videoPath.split('/').last;
        final newImagePath = '${directory.path}/$imageFileName';
        await file.copy(newImagePath);
        Get.back();
        Share.shareXFiles([XFile(newImagePath)], text: text);
      } else {
        showToast("video file not found");
      }
    } else {
      showToast("video path is null or empty");
    }
  }
}
