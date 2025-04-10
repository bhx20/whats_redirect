import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/reusable/loader/simmer.dart';

import '../../../controller/status_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_typography.dart';

class MediaView extends StatelessWidget {
  const MediaView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatusController>(builder: (controller) {
      if (controller.isWhatsApp()) {
        return Obx(() {
          if (controller.isLoaded.isTrue) {
            if (controller.mediaList.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    _buildFilterList(controller),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1 / 1,
                          crossAxisSpacing: 5.h,
                          mainAxisSpacing: 5.h,
                        ),
                        itemCount: controller.filteredMediaList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final File file =
                              controller.filteredMediaList[index].file;
                          final bool isVideo =
                              controller.filteredMediaList[index].isVideo;
                          return _buildMediaItem(
                              context, file, isVideo, controller);
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return _noDataView();
            }
          } else {
            return _buildLoader();
          }
        });
      } else {
        return _noWhatsappView();
      }
    });
  }

  Widget _buildFilterList(StatusController c) {
    return Row(
      children: List.generate(
        c.filterList.length,
        (index) => GestureDetector(
          onTap: () {
            c.updateFilter(index);
          },
          child: Container(
            decoration: BoxDecoration(
                color: c.selectedCategory.value == index
                    ? appColors.filterBg
                    : appColors.unfocusedFilterBg,
                borderRadius: BorderRadius.circular(100)),
            margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 3.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            child: Center(
                child: Text(
              c.filterList[index],
              style: typo.w500.textColor(
                c.selectedCategory.value == index
                    ? appColors.filterTitle
                    : appColors.unfocusedFilterTitle,
              ),
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return Container(
      margin: EdgeInsets.all(5.h),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1 / 1,
          crossAxisSpacing: 5.h,
          mainAxisSpacing: 5.h,
        ),
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(5.h),
            child: const SimmerLoader(radius: 100),
          );
        },
      ),
    );
  }

  Widget _buildMediaItem(BuildContext context, File file, bool isVideo,
      StatusController controller) {
    Widget imageView(File file) {
      return Image.file(
        file,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.low,
      );
    }

    Widget videoView(File file) {
      return FutureBuilder<File?>(
        future: controller.generateThumbnail(file),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SimmerLoader(
              radius: 10,
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error generating thumbnail',
              textAlign: TextAlign.center,
              style: typo.get8,
            ));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
                child: Text(
              'No Thumbnail Available',
              textAlign: TextAlign.center,
              style: typo.get8,
            ));
          } else {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
                ),
                Icon(
                  Icons.play_arrow,
                  color: appColors.white,
                  size: 20.h,
                )
              ],
            );
          }
        },
      );
    }

    return GestureDetector(
      onTap: () {
        controller.openMedia(context, file, isVideo);
      },
      child: Container(
        margin: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: appColors.appColor, width: 2.5)),
        child: Padding(
          padding: EdgeInsets.all(1.5.h),
          child: ClipOval(
            child: isVideo ? videoView(file) : imageView(file),
          ),
        ),
      ),
    );
  }

  Widget _noWhatsappView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Looks like WhatsApp is not installed on your device. To access and"
            " download WhatsApp statuses within this app, please consider"
            " installing WhatsApp. Download WhatsApp to enjoy status updates"
            " from your contacts. Stay connected!",
            textAlign: TextAlign.center,
            style: typo.w500.get10,
          ),
        ],
      ),
    );
  }

  Widget _noDataView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Oops! It looks like there are no images available for download."
            " To start collecting status images, make sure to view some "
            "statuses in your WhatsApp. Once you've checked them out, the "
            "images will be ready for you here. Explore your friends' "
            "updates and enjoy downloading status images!",
            textAlign: TextAlign.center,
            style: typo.w500.get10,
          ),
        ],
      ),
    );
  }
}
