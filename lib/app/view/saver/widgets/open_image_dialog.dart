import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/status_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_typography.dart';
import '../../../reusable/icon/action_icon.dart';
import '../../../reusable/menu/status_manu.dart';

openImage(BuildContext context, String imagePath) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: appColors.black,
    builder: (BuildContext context) {
      return OpenImageDialog(
        imagePath: imagePath,
      );
    },
  );
}

class OpenImageDialog extends StatefulWidget {
  final String imagePath;
  const OpenImageDialog({super.key, required this.imagePath});

  @override
  State<OpenImageDialog> createState() => _OpenImageDialogState();
}

class _OpenImageDialogState extends State<OpenImageDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isPopUp = false;
  double lastAnimationValue = 0.0;
  bool isTextFieldFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted && !isPopUp) {
        Get.back();
      }
    });

    _controller.forward();
  }

  void pauseAnimation() {
    if (_controller.isAnimating) {
      lastAnimationValue = _controller.value;
      _controller.stop();
    }
  }

  void resumeAnimation() {
    _controller.forward(from: lastAnimationValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        body: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.fitWidth,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [leadingPanel(), sharePanel()],
            )
          ],
        ),
      ),
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
                  value: _controller.value,
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
                onSubmitted: (v) {
                  Get.back();
                  c.shareImage(widget.imagePath, input.text);
                },
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
                  c.downloadImage(widget.imagePath);
                },
              ),
            ),
            ActionIcon(
              Icons.send,
              onTap: () {
                Get.back();
                c.shareImage(widget.imagePath, input.text);
              },
            )
          ],
        ));
  }
}
