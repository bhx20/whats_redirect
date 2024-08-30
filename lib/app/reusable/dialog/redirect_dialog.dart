import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/core/app_colors.dart';
import 'package:redirect/app/core/app_typography.dart';
import 'package:redirect/app/module/redirect/redirect_controller.dart';

import '../../model/user_number_model.dart';
import '../app_field/app_feild.dart';

redirect(context, {UserNumber? data, String? number}) {
  redirectDialog(UserNumber? data) {
    TextEditingController dialogController =
        TextEditingController(text: data != null ? data.number : "");
    TextEditingController autoController =
        TextEditingController(text: number ?? "");
    FocusNode inputNode = FocusNode();
    FocusScope.of(context).requestFocus(inputNode);
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
            Text(data != null ? 'Edit Number' : "Redirect Number",
                style: typo.get18),
            SizedBox(height: 10.h),
            AppTextField(
              prefix: const Icon(Icons.person_add_outlined),
              controller: number != null
                  ? autoController
                  : data != null
                      ? dialogController
                      : c.phoneController,
              hintText: "Phone Number",
              autofocus: true,
              focusNode: inputNode,
              maxLength: 15,
            ),
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
                      if (number != null) {
                        String phoneNumber = autoController.text;
                        c.launchWhatsApp(phoneNumber);
                      } else {
                        if (data != null) {
                          Map<String, dynamic> row = {
                            "Number": dialogController.text,
                          };
                          c.dbHelper.update("USER_NUMBER", data.dbId ?? 0, row);
                          c.getUserNumber();
                        } else {
                          String phoneNumber = c.phoneController.text;
                          c.launchWhatsApp(phoneNumber);
                        }
                      }

                      Get.back();
                    },
                    child: Text(
                      data != null ? "Update" : "Redirect",
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
      return redirectDialog(
        data,
      );
    },
  );
}
