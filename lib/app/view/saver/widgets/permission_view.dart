import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/status_controller.dart';
import '../../../core/app_typography.dart';
import '../../../reusable/button/app_button.dart';
import '../../../reusable/generated_scaffold.dart';

class PermissionView extends GetView<StatusController> {
  const PermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'To download and save status updates, We requires access'
              ' to your device\'s storage. This permission is necessary to '
              'save the status images and videos locally on your phone,We '
              'respect your privacy and assure you that Status Saver will'
              ' only use this permission for the intended purpose of saving'
              ' Statuses. Your media files will be stored securely '
              'on your device, and we do not access or share them with any'
              ' third parties.',
              textAlign: TextAlign.center,
              style: typo.w500.get10,
            ),
            SizedBox(height: 20.h),
            AppButton(
                text: "Grant Permission",
                onPressed: () {
                  controller.requestPermission();
                },
                width: 150.w)
          ],
        ),
      ),
    );
  }
}
