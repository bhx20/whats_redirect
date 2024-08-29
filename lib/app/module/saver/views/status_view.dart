import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/core/app_typography.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<StatusController>().permissionCheck =
          Get.find<StatusController>().getPermissionStatus();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: _topBar(),
      body: GetBuilder<StatusController>(
        init: StatusController(),
        builder: (controller) {
          return FutureBuilder<int>(
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
          );
        },
      ),
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
              mainAxisSpacing: 5.h),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return const SimmerLoader(radius: 10);
          },
        ));
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
                onPressed: () {},
                icon: const Icon(Icons.refresh, color: Color(0xff54656f)),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _topBar() {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: const Text(
        'What\'s Saver',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1daa61)),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.refresh, color: Color(0xff54656f)),
        )
      ],
    );
  }
}
