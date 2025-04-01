import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/core/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class SimmerLoader extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? decorationColor;

  const SimmerLoader({
    super.key,
    this.height,
    this.width,
    this.radius,
    this.padding,
    this.margin,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: appColors.simmerBase,
      highlightColor: appColors.simmerHighLight,
      child: Container(
        margin: margin,
        width: width ?? Get.width,
        height: height ?? 50.h,
        decoration: BoxDecoration(
          color: decorationColor ?? appColors.simmerHighLight,
          borderRadius: BorderRadius.circular(radius ?? 5),
        ),
      ),
    );
  }
}
