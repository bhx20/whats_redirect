import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';

class ActionIcon extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  final double? size;
  const ActionIcon(
    this.icon, {
    super.key,
    required this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.xffdbfed4,
        ),
        child: Padding(
          padding: EdgeInsets.all(5.h),
          child: Icon(
            icon,
            color: AppColors.xff185E3C,
            size: size ?? 13.h,
          ),
        ),
      ),
    );
  }
}
