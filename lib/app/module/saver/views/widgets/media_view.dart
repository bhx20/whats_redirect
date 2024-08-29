import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:redirect/app/module/saver/views/widgets/open_video_dialog.dart';
import 'package:redirect/app/reusable/icon/action_icon.dart';
import 'package:redirect/app/reusable/loader/simmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../core/app_typography.dart';
import '../../../../model/local.dart';
import '../../../../reusable/globle.dart';
import 'open_image_dialog.dart';

class MediaView extends StatefulWidget {
  const MediaView({super.key});

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  final Directory directory = Directory(
      '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
  RxList<MediaType> mediaList = <MediaType>[].obs;
  var isLoaded = false.obs;

  @override
  void initState() {
    super.initState();
    getStatusData();
  }

  void getStatusData() {
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
    }
  }

  bool _isValidMedia(String path) {
    final extension = path.split('.').last.toLowerCase();
    return ['jpg'].contains(extension) || ['mp4'].contains(extension);
  }

  bool _isVideo(String path) {
    final extension = path.split('.').last.toLowerCase();
    return ['mp4'].contains(extension);
  }

  void _openMedia(File file, bool isVideo) {
    if (isVideo) {
      openVideo(context, file);
    } else {
      openImage(context, file.path);
    }
  }

  downloadImage(String imgPath) async {
    final myUri = Uri.parse(imgPath);
    final originalImageFile = File.fromUri(myUri);
    late Uint8List bytes;
    await originalImageFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
    }).catchError((onError) {});
    await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
    showToast("Image Downloaded Successfully");
  }

  downloadVideo(File file) async {
    final result =
        await ImageGallerySaver.saveFile(file.path, isReturnPathOfIOS: true);
    if (result['isSuccess'] == true) {
      showToast("Video Downloaded Successfully");
    } else {
      showToast("Failed to Download Video");
    }
  }

  bool isWhatsApp() {
    return Directory(directory.path).existsSync();
  }

  Future<File?> _generateThumbnail(File videoFile) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoFile.path,
      thumbnailPath: (await Directory.systemTemp.createTemp()).path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 1280,
      quality: 75,
    );
    return thumbnail != null ? File(thumbnail) : null;
  }

  @override
  Widget build(BuildContext context) {
    if (isWhatsApp()) {
      return Obx(() {
        if (isLoaded.isTrue) {
          if (mediaList.isNotEmpty) {
            return Container(
              margin: EdgeInsets.all(5.h),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 5.h,
                  mainAxisSpacing: 5.h,
                ),
                itemCount: mediaList.length,
                itemBuilder: (BuildContext context, int index) {
                  final File file = mediaList[index].file;
                  final bool isVideo = mediaList[index].isVideo;
                  return _buildMediaItem(file, isVideo);
                },
              ),
            );
          } else {
            return _noDataView();
          }
        } else {
          return Container(
            margin: EdgeInsets.all(5.h),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 5.h,
                mainAxisSpacing: 5.h,
              ),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return const SimmerLoader(radius: 10);
              },
            ),
          );
        }
      });
    } else {
      return _noWhatsappView();
    }
  }

  Widget _buildMediaItem(File file, bool isVideo) {
    Widget imageView(File file) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            file,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
          ),
          Align(
              alignment: Alignment.topRight,
              child: ActionIcon(
                Icons.download,
                onTap: () {
                  downloadImage(file.path);
                },
              )),
        ],
      );
    }

    Widget videoView(File file) {
      return FutureBuilder<File?>(
        future: _generateThumbnail(file),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SimmerLoader(
              radius: 10,
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error generating thumbnail',
              textAlign: TextAlign.center,
              style: typo.black.get8,
            ));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
                child: Text(
              'No Thumbnail Available',
              textAlign: TextAlign.center,
              style: typo.black.get8,
            ));
          } else {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: ActionIcon(
                      Icons.download,
                      onTap: () {
                        downloadVideo(file);
                      },
                    )),
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 35.h,
                )
              ],
            );
          }
        },
      );
    }

    return GestureDetector(
      onTap: () {
        _openMedia(file, isVideo);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: isVideo ? videoView(file) : imageView(file),
      ),
    );
  }

  Widget _noWhatsappView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Looks like WhatsApp is not installed on your device. To access and"
            " download WhatsApp statuses within this app, please consider"
            " installing WhatsApp. Download WhatsApp to enjoy status updates"
            " from your contacts. Stay connected!",
            textAlign: TextAlign.center,
            style: typo.w500.get10,
          ),
        ],
      ),
    );
  }

  Widget _noDataView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Oops! It looks like there are no images available for download."
            " To start collecting status images, make sure to view some "
            "statuses in your WhatsApp. Once you've checked them out, the "
            "images will be ready for you here. Explore your friends' "
            "updates and enjoy downloading status images!",
            textAlign: TextAlign.center,
            style: typo.w500.get10,
          ),
        ],
      ),
    );
  }
}
