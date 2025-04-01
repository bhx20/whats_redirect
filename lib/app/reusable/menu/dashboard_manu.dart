import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/controller/redirect_controller.dart';

import '../../core/app_colors.dart';
import '../../core/app_typography.dart';
import '../dialog/warning_dialog.dart';

showDashBoardManu() {
  var c = Get.find<RedirectController>();
  showMenu(
    context: Get.context!,
    position: const RelativeRect.fromLTRB(0, 0, -100, 0),
    items: c.items.asMap().entries.map((entry) {
      int index = entry.key;
      var item = entry.value;

      return PopupMenuItem<int>(
        value: index + 1,
        onTap: () {
          if (index == 0) {
            Get.back();
            c.getUserNumber();
          } else if (index == 1) {
            Get.back();
            c.help();
          } else {
            warningDialog(Get.context!);
          }
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10.h, left: 5.h),
              child: Icon(
                item.icon,
                size: 15.h,
                color: appColors.xff185E3C,
              ),
            ),
            Text(
              item.title,
              style: typo.get10.black.w700,
            ),
          ],
        ),
      );
    }).toList(),
  );
}
