import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/app_colors.dart';
import '../../core/app_typography.dart';

warningDialog(context) {
  warningView() {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Are you sure you want to Close the App?", style: typo.get15),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: Text(
                      "Yes",
                      style: typo.get12.w700.textColor(AppColors.xff1DAB61),
                    )),
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "No",
                      style: typo.get12.w700.textColor(AppColors.xff1DAB61),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return warningView();
    },
  );
}
