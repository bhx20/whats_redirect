import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:redirect/app/core/app_typography.dart';

import '../../core/app_colors.dart';

class ActionIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onTap;
  const ActionIcon(
    this.icon, {
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 30.h,
        width: 120.w,
        decoration: BoxDecoration(
            color: appColors.secondarySlideBg,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: appColors.secondarySlideTitle,
              size: 13.h,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: typo.w500.textColor(appColors.secondarySlideTitle).get12,
            )
          ],
        ),
      ),
    );
  }
}
