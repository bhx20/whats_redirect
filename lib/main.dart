import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:redirect/app/uttils/local_db/sql_helper.dart';

import 'app/core/app_typography.dart';
import 'app/reusable/initial_binding.dart';
import 'app/reusable/scroll_behavior/scroll_behavior.dart';
import 'app/uttils/local_db/prefrances.dart';
import 'app/view/dashboard/dashBoard_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.instance.initDataBase();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await PreferenceHelper.instance.createSharedPref();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'WhatsApp Redirect',
          scrollBehavior: CustomScrollBehavior(),
          theme: ThemeData(fontFamily: TextFontFamily.roboto),
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          home: const DashBoardView(),
        );
      },
    );
  }
}
