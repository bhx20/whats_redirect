import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentPageIndex = 0.obs;

  RxBool showBadge = true.obs;

  void changePage(int index) {
    currentPageIndex.value = index;
    if (index == 1) {
      showBadge.value = false;
    }
    update();
  }
}
