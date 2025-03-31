import 'package:get/get.dart';

import '../controller/redirect_controller.dart';
import '../controller/status_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InitialController());
  }
}

class InitialController extends GetxController {
  @override
  void onInit() {
    Get.put(RedirectController()).getUserNumber();
    Get.put(StatusController()).getStatusData();
    ();

    super.onInit();
  }
}
