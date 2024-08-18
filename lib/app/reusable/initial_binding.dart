import 'package:get/get.dart';

import '../module/redirect/redirect_controller.dart';

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
    super.onInit();
  }
}
