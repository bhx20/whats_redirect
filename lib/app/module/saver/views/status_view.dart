import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/core/app_typography.dart';

import '../../../core/app_colors.dart';
import '../../../reusable/dialog/warning_dialog.dart';
import '../../../reusable/generated_scaffold.dart';
import '../../../reusable/loader/simmer.dart';
import '../controllers/status_controller.dart';
import 'widgets/media_view.dart';
import 'widgets/permission_view.dart';

class StatusView extends StatefulWidget {
  const StatusView({super.key});

  @override
  _StatusViewState createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> with WidgetsBindingObserver {
  late StatusController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = Get.find<StatusController>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // Check permissions when app is resumed
      int permissionStatus = await _controller.getPermissionStatus();

      if (permissionStatus == 1) {
        // Refresh the data if permission is granted
        _controller.getStatusData();
        setState(() {}); // Ensure the UI is updated
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatusController>(
      init: StatusController(),
      builder: (controller) {
        return AppScaffold(
          appBar: _topBar(controller),
          body: FutureBuilder<int>(
            future: controller.permissionCheck,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return snapshot.data == 1
                      ? const MediaView()
                      : const PermissionView();
                } else {
                  return _errorView(controller);
                }
              } else {
                return _loadingView();
              }
            },
          ),
        );
      },
    );
  }

  Widget _loadingView() {
    return Container(
      margin: EdgeInsets.all(5.h),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 5.h,
          mainAxisSpacing: 5.h,
        ),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return const SimmerLoader(radius: 10);
        },
      ),
    );
  }

  Widget _errorView(StatusController controller) {
    return AppScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Something went wrong. \nPlease reload or try again later.",
                textAlign: TextAlign.center,
                style: typo.w500.get10,
              ),
              IconButton(
                onPressed: () {
                  controller.getStatusData();
                },
                icon: const Icon(Icons.refresh, color: Color(0xff54656f)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _topBar(StatusController c) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: const Text(
        'What\'s Saver',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1daa61)),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showMenu(
              color: AppColors.white,
              context: Get.context!,
              elevation: 0.5,
              position: const RelativeRect.fromLTRB(0, 0, -100, 0),
              items: c.items.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;

                return PopupMenuItem<int>(
                  value: index + 1,
                  onTap: () {
                    if (index == 0) {
                      Get.back();
                      c.getStatusData();
                    } else if (index == 1) {
                      Get.back();
                      c.help();
                    } else {
                      warningDialog(context);
                    }
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.h, left: 5.h),
                        child: Icon(
                          item.icon,
                          size: 15.h,
                          color: AppColors.xff185E3C,
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
          },
          icon: const Icon(Icons.more_vert_outlined, color: Color(0xff54656f)),
        ),
      ],
    );
  }
}
