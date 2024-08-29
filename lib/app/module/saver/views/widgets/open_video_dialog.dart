import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redirect/app/core/app_colors.dart';
import 'package:redirect/app/reusable/icon/action_icon.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../../../reusable/globle.dart';

openVideo(BuildContext context, File file) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return OpenVideoWidget(
        file: file,
      );
    },
  );
}

class OpenVideoWidget extends StatefulWidget {
  final File file;

  const OpenVideoWidget({super.key, required this.file});

  @override
  _OpenVideoWidgetState createState() => _OpenVideoWidgetState();
}

class _OpenVideoWidgetState extends State<OpenVideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InkWell(
        onTap: () {
          Get.back();
        },
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    if (_controller.value.isPlaying)
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _controller.pause();
                            });
                          },
                          icon: Icon(
                            Icons.pause,
                            color: AppColors.white,
                            size: 30.h,
                          ))
                    else
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _controller.play();
                            });
                          },
                          icon: Icon(
                            Icons.play_arrow,
                            color: AppColors.white,
                            size: 30.h,
                          ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ActionIcon(
              Icons.download,
              size: 20.h,
              onTap: () async {
                downloadVideo(widget.file);
              },
            ),
            ActionIcon(
              Icons.share,
              size: 20.h,
              onTap: () {
                Get.back();
                shareOn(widget.file.path);
              },
            ),
          ],
        ),
      ),
    );
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

  void shareOn(String videoPath) async {
    if (videoPath.isNotEmpty) {
      final file = File(videoPath);
      if (await file.exists()) {
        final directory = await getTemporaryDirectory();
        final imageFileName = videoPath.split('/').last;
        final newImagePath = '${directory.path}/$imageFileName';
        await file.copy(newImagePath);
        Share.shareXFiles([XFile(newImagePath)]);
      } else {
        showToast("video file not found");
      }
    } else {
      showToast("video path is null or empty");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
