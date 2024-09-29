import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/core/app_colors.dart';
import 'package:redirect/app/reusable/icon/action_icon.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/status_controller.dart';

openVideo(BuildContext context, File file) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: AppColors.trans,
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
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      onTap: () {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      },
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            GetBuilder<StatusController>(builder: (controller) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionIcon(
                Icons.download,
                size: 20.h,
                onTap: () {
                  controller.downloadVideo(widget.file);
                },
              ),
              ActionIcon(
                Icons.share,
                size: 20.h,
                onTap: () {
                  Get.back();
                  controller.shareVideo(widget.file.path);
                },
              )
            ],
          );
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
