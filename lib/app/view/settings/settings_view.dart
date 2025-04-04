import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redirect/app/reusable/generated_scaffold.dart';

import '../../controller/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: GetBuilder(
            init: SettingsController(),
            builder: (c) => Column(
                  children: [
                    ListTile(
                      title: Text("Light Mode"),
                      leading: Obx(() => Radio(
                            value: ThemeMode.light,
                            groupValue: c.themeService.themeMode.value,
                            onChanged: (value) => c.setTheme(ThemeMode.light),
                          )),
                    ),
                    ListTile(
                      title: Text("Dark Mode"),
                      leading: Obx(() => Radio(
                            value: ThemeMode.dark,
                            groupValue: c.themeService.themeMode.value,
                            onChanged: (value) => c.setTheme(ThemeMode.dark),
                          )),
                    ),
                    ListTile(
                      title: Text("System Default"),
                      leading: Obx(() => Radio(
                            value: ThemeMode.system,
                            groupValue: c.themeService.themeMode.value,
                            onChanged: (value) => c.setTheme(ThemeMode.system),
                          )),
                    ),
                  ],
                )));
  }
}
