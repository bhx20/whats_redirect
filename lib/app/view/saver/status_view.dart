import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/core/app_typography.dart';
import 'package:redirect/app/reusable/menu/dashboard_manu.dart';
import 'package:redirect/app/view/saver/widgets/media_view.dart';
import 'package:redirect/app/view/saver/widgets/permission_view.dart';

import '../../controller/status_controller.dart';
import '../../reusable/generated_scaffold.dart';

class StatusView extends StatefulWidget {
  const StatusView({super.key});

  @override
  _StatusViewState createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> with WidgetsBindingObserver {
  late StatusController _controller;
  RxBool isMore = false.obs;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = Get.find<StatusController>();
    getMore();
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
      _controller.permissionCheck = _controller.getPermissionStatus();

      if (await _controller.permissionCheck == 1) {
        isMore(true);
        _controller.getStatusData();
        setState(() {}); // Ensure the UI is updated
      }
    }
  }

  getMore() async {
    if (await _controller.permissionCheck == 1) {
      isMore(true);

      setState(() {}); // Ensure the UI is updated
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
                return SizedBox();
              }
            },
          ),
        );
      },
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
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _topBar(StatusController c) {
    return AppBar(
      title: Text(
        'What\'s Saver',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: [
        if (isMore.isTrue)
          IconButton(
            onPressed: () {
              showDashBoardManu();
            },
            icon: const Icon(Icons.more_vert_outlined),
          ),
      ],
    );
  }
}
