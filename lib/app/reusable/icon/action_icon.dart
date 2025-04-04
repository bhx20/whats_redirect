import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';

class ActionIcon extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  const ActionIcon(
    this.icon, {
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 42.h,
        width: 42.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: appColors.darkFieldBackground,
        ),
        child: Icon(
          icon,
          color: appColors.white,
          size: 18.h,
        ),
      ),
    );
  }
}
