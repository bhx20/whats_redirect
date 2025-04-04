import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/controller/redirect_controller.dart';
import 'package:redirect/app/core/app_colors.dart';
import 'package:redirect/app/reusable/globle.dart';

import '../../core/app_typography.dart';
import '../../core/constants.dart';

showDashBoardManu({required Function() onRefresh}) {
  var c = Get.find<RedirectController>();
  final RenderBox renderBox =
      menuKey.currentContext!.findRenderObject() as RenderBox;
  final Offset position = renderBox.localToGlobal(Offset.zero);
  showMenu(
    context: Get.context!,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + renderBox.size.height,
      position.dx + renderBox.size.width,
      0,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    elevation: 0.5,
    items: c.items.asMap().entries.map((entry) {
      int index = entry.key;
      var item = entry.value;

      return PopupMenuItem<int>(
        value: index + 1,
        onTap: () {
          if (index == 0) {
            Get.back();
            onRefresh();
          } else if (index == 1) {
            Get.back();
            c.helpSupport();
          } else {
            showToast("This feature is under Development");
          }
        },
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(right: 10.h, left: 5.h),
                child: Obx(
                  () => Icon(
                    item.icon,
                    size: 18.h,
                    color: appColors.popIconColor,
                  ),
                )),
            Text(
              item.title,
              style: typo.get12.w500,
            ),
          ],
        ),
      );
    }).toList(),
  );
}
