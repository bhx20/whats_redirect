import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/controller/redirect_controller.dart';

import '../../core/app_colors.dart';
import '../../core/app_typography.dart';
import '../../model/user_number_model.dart';

deleteDialog(context, {required UserNumber data}) {
  deleteView(UserNumber data) {
    var c = Get.put(RedirectController());
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Are you sure you want to Delete this number?",
                style: typo.get18),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Cancel",
                      style: typo.get12.w700.textColor(AppColors.xff1DAB61),
                    )),
                TextButton(
                    onPressed: () {
                      c.dbHelper
                          .deleteQuery("USER_NUMBER", data.dbId ?? 0, "dbId");
                      c.getUserNumber();
                      Get.back();
                    },
                    child: Text(
                      "Delete",
                      style: typo.get12.w700.textColor(AppColors.xff1DAB61),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return deleteView(
        data,
      );
    },
  );
}
