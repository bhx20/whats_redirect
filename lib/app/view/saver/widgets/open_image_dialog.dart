import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/controller/status_controller.dart';

import '../../../core/app_colors.dart';
import '../../../reusable/icon/action_icon.dart';

openImage(BuildContext context, String imagePath) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: appColors.trans,
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
    return Container(
      decoration: BoxDecoration(
          color: appColors.dialogBG,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      height: Get.height * 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: GetBuilder<StatusController>(builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionIcon(
                    Icons.download,
                    title: "Download",
                    onTap: () {
                      controller.downloadImage(imagePath);
                    },
                  ),
                  ActionIcon(
                    Icons.share,
                    title: "Share",
                    onTap: () {
                      Get.back();
                      controller.shareImage(imagePath);
                    },
                  )
                ],
              );
            })),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w).copyWith(top: 5.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(20.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
