import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redirect/app/core/app_colors.dart';
import 'package:redirect/app/reusable/generated_scaffold.dart';

import '../../controller/dashBoard_controller.dart';
import '../../reusable/dialog/redirect_dialog.dart';
import '../../reusable/dialog/warning_dialog.dart';
import '../../uttils/local_db/prefrances.dart';
import '../redirect/redirect_view.dart';
import '../saver/status_view.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({super.key});

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  @override
  void initState() {
    getClipboardData();
    super.initState();
  }

  Future<void> getClipboardData() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      final String clipboardText = data.text!.trim();
      final RegExp phoneRegExp = RegExp(r'^\+?\d+$');
      if (phoneRegExp.hasMatch(clipboardText)) {
        final String? lastShownNumber =
            await PreferenceHelper.instance.getData(Pref.lastShownNumber);
        if (lastShownNumber != clipboardText) {
          redirect(context, number: clipboardText);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: DashboardController(),
        builder: (c) {
          return PopScope(
            canPop: false,
            onPopInvoked: (value) {
              if (c.currentPageIndex.value == 1) {
                c.currentPageIndex.value = 0;
                c.update();
              } else {
                warningDialog(context);
              }
            },
            child: AppScaffold(
              bottomNavigationBar: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    height: 0,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  Obx(
                    () => NavigationBar(
                      selectedIndex: c.currentPageIndex.value,
                      onDestinationSelected: (int index) {
                        c.changePage(index); // Use the new method
                      },
                      destinations: [
                        NavigationDestination(
                          selectedIcon:
                              ImageIcon(AssetImage("assets/redirect_fill.png")),
                          icon: ImageIcon(AssetImage("assets/redirect.png")),
                          label: 'Redirect',
                        ),
                        NavigationDestination(
                          selectedIcon:
                              ImageIcon(AssetImage("assets/saver_fill.png")),
                          icon: Obx(() => c.showBadge.value
                              ? Badge(
                                  backgroundColor: appColors.buttonForeground,
                                  child:
                                      ImageIcon(AssetImage("assets/saver.png")),
                                )
                              : ImageIcon(AssetImage("assets/saver.png"))),
                          label: 'Saver',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              body: [
                const RedirectView(),
                const StatusView(),
              ][c.currentPageIndex.value],
            ),
          );
        });
  }
}
