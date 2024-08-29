import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/core/app_colors.dart';
import 'package:redirect/app/reusable/generated_scaffold.dart';

import '../../core/app_typography.dart';
import '../redirect/redirect_view.dart';
import '../saver/views/status_view.dart';
import 'dashBoard_controller.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({super.key});

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: DashboardController(),
        builder: (c) {
          return AppScaffold(
            bottomNavigationBar: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: AppColors.white,
                indicatorColor: AppColors.xffdbfed4,
                elevation: 0,
                labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return typo.w700.get11;
                    }
                    return typo.w500.get11;
                  },
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    height: 0,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  NavigationBar(
                    selectedIndex: c.currentPageIndex.value,
                    onDestinationSelected: (int index) {
                      c.currentPageIndex(index);
                      c.update();
                    },
                    destinations: [
                      NavigationDestination(
                        selectedIcon: Image.asset(
                          "assets/redirect_fill.png",
                          height: 13.h,
                        ),
                        icon: Image.asset(
                          "assets/redirect.png",
                          height: 13.h,
                        ),
                        label: 'What\'s Redirect',
                      ),
                      NavigationDestination(
                        icon: Image.asset(
                          "assets/saver.png",
                          height: 22.h,
                        ),
                        selectedIcon: Image.asset(
                          "assets/saver_fill.png",
                          height: 22.h,
                        ),
                        label: 'Status Saver',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: [
              const RedirectView(),
              const StatusView(),
            ][c.currentPageIndex.value],
          );
        });
  }
}
