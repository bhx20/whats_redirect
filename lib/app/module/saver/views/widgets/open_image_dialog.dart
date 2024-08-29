import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/module/saver/controllers/status_controller.dart';

import '../../../../reusable/icon/action_icon.dart';

openImage(BuildContext context, String imagePath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return OpenImageDialog(
        imagePath: imagePath,
      );
    },
  );
}

class OpenImageDialog extends StatelessWidget {
  final String imagePath;
  const OpenImageDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: GetBuilder<StatusController>(builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionIcon(
                  Icons.download,
                  size: 20.h,
                  onTap: () {
                    controller.downloadImage(imagePath);
                  },
                ),
                ActionIcon(
                  Icons.share,
                  size: 20.h,
                  onTap: () {
                    Get.back();
                    controller.shareImage(imagePath);
                  },
                )
              ],
            );
          })),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
