import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:redirect/app/reusable/icon/action_icon.dart';
import 'package:redirect/app/reusable/loader/simmer.dart';
import 'package:video_player/video_player.dart';

import '../../../controller/status_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_typography.dart';
import '../../../reusable/menu/status_manu.dart';

void openVideo(BuildContext context, File file) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    useSafeArea: false,
    backgroundColor: appColors.black,
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

class _OpenVideoWidgetState extends State<OpenVideoWidget>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animController;
  RxBool isLoading = true.obs;
  double lastAnimationValue = 0.0;
  bool isPopUp = false;
  bool isTextFieldFocused = false;

  @override
  void initState() {
    super.initState();
    playVideo();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  playVideo() {
    try {
      isLoading(true);
      _controller = VideoPlayerController.file(widget.file)
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        }).then((v) {
          _animController = AnimationController(
            vsync: this,
            duration: _controller.value.duration,
          );
          isLoading(false);
          _animController.addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted && !isPopUp) {
              Get.back();
            }
          });
          _animController.forward();
        });
    } catch (e) {
      isLoading(false);
      Get.back();
    }
  }

  void pauseAnimation() {
    if (_animController.isAnimating) {
      _controller.pause();
      lastAnimationValue = _animController.value;
      _animController.stop();
    }
  }

  void resumeAnimation() {
    _controller.play();
    _animController.forward(from: lastAnimationValue);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: appColors.black,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: appColors.black,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
          backgroundColor: appColors.black,
          body: Obx(() {
            if (isLoading.isTrue) {
              return SimmerLoader(
                height: Get.height,
              );
            } else {
              return Stack(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        if (_controller.value.isPlaying) {
                          pauseAnimation();
                        } else {
                          resumeAnimation();
                        }
                      },
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [leadingPanel(), sharePanel()],
                  )
                ],
              );
            }
          })),
    );
  }

  Widget leadingPanel() {
    return Column(
      children: [
        SizedBox(height: 40),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scaleY: 0.7,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.h),
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular((20)),
                  value: _animController.value,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back, color: appColors.white)),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage("assets/logo.png"),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What's Saver",
                            style: typo.w500.get14
                                .copyWith(color: appColors.white),
                          ),
                          Text(
                            "Today, ${DateFormat('hh:mm a').format(DateTime.now())}",
                            maxLines: 1,
                            style: typo.get10.w500
                                .copyWith(color: appColors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      pauseAnimation();
                      isPopUp = true;
                      showStatusManu(action: () {
                        isPopUp = false;
                        resumeAnimation();
                      });
                    },
                    icon: Icon(
                      Icons.more_vert_outlined,
                      color: appColors.white,
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget sharePanel() {
    var c = Get.find<StatusController>();
    final TextEditingController input = TextEditingController();
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: input,
                keyboardType: TextInputType.text,
                cursorColor: appColors.appColor,
                style: typo.get14.w400.copyWith(color: appColors.white),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "Add share text here...",
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                  prefixIconColor: appColors.darkFieldPrefix,
                  fillColor: appColors.darkFieldBackground,
                  hintStyle: typo
                      .copyWith(color: appColors.darkText.withOpacity(0.5))
                      .get12,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appColors.trans),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appColors.trans),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: appColors.trans),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ActionIcon(
                Icons.cloud_download,
                onTap: () {
                  c.downloadVideo(widget.file);
                },
              ),
            ),
            ActionIcon(
              Icons.send,
              onTap: () {
                Get.back();
                c.shareVideo(widget.file.path, input.text);
              },
            )
          ],
        ));
  }
}
