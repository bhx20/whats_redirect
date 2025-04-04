import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:redirect/app/controller/redirect_controller.dart';
import 'package:redirect/app/core/app_colors.dart';
import 'package:redirect/app/core/app_typography.dart';

import '../../model/local.dart';
import '../../model/user_number_model.dart';
import '../../uttils/local_db/prefrances.dart';
import '../app_field/app_feild.dart';

redirect(context, {UserNumber? data, String? number}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return RedirectWidget(data: data, number: number);
    },
  );
}

class RedirectWidget extends StatefulWidget {
  final UserNumber? data;
  final String? number;

  const RedirectWidget({super.key, this.data, this.number});

  @override
  State<RedirectWidget> createState() => _RedirectWidgetState();
}

class _RedirectWidgetState extends State<RedirectWidget> {
  late TextEditingController dialogController;
  late TextEditingController autoController;
  var c = Get.put(RedirectController());
  String initialSelection = 'IN';
  @override
  void initState() {
    dialogController = TextEditingController(
        text: widget.data != null ? widget.data?.number : "");
    autoController = TextEditingController(text: widget.number ?? "");

    if (widget.data != null) {
      initialSelection = widget.data?.origin ?? "IN";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (value, data) async {
        if (widget.number != null) {
          await PreferenceHelper.instance
              .setData(Pref.lastShownNumber, widget.number);
        }
      },
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.data != null ? 'Edit Number' : "Redirect Number",
                  style: typo.get15),
              SizedBox(height: 10.h),
              AppTextField(
                prefix: countryCode(),
                controller: widget.number != null
                    ? autoController
                    : widget.data != null
                        ? dialogController
                        : c.phoneController,
                hintText: "Phone Number",
                autofocus: true,
                maxLength: 15,
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () async {
                        if (widget.number != null) {
                          await PreferenceHelper.instance
                              .setData(Pref.lastShownNumber, widget.number);
                        }

                        Get.back();
                      },
                      child: Text(
                        "Cancel",
                        style: typo.get12.w700.textColor(appColors.appColor),
                      )),
                  TextButton(
                      onPressed: () async {
                        if (widget.number != null) {
                          await PreferenceHelper.instance
                              .setData(Pref.lastShownNumber, widget.number);
                          NumberData data = NumberData(
                              number: autoController.text,
                              origin: c.selectedCountryOrigin.value,
                              code: c.selectedCountryCode.value);
                          c.launchWhatsApp(data);
                        } else {
                          if (widget.data != null) {
                            Map<String, dynamic> row = {
                              "Number": dialogController.text,
                              "CountryOrigin": c.selectedCountryOrigin.value,
                              "CountryCode": c.selectedCountryCode.value
                            };
                            c.dbHelper.update(
                                "USER_NUMBER", widget.data?.dbId ?? 0, row);
                            c.getUserNumber();
                          } else {
                            NumberData data = NumberData(
                                number: c.phoneController.text,
                                origin: c.selectedCountryOrigin.value,
                                code: c.selectedCountryCode.value);
                            c.launchWhatsApp(data);
                          }
                        }

                        Get.back();
                      },
                      child: Text(
                        widget.data != null ? "Update" : "Redirect",
                        style: typo.get12.w700.textColor(appColors.appColor),
                      )),
                  if (widget.data == null)
                    TextButton(
                        onPressed: () async {
                          NumberData data = NumberData(
                              number: c.phoneController.text,
                              origin: c.selectedCountryOrigin.value,
                              code: c.selectedCountryCode.value);
                          c.saveNumber(data);
                          Get.back();
                        },
                        child: Text(
                          "Save",
                          style: typo.get12.w700.textColor(appColors.appColor),
                        )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget countryCode() {
    return CountryCodePicker(
      onChanged: (code) {
        c.selectedCountryCode(code.dialCode);
        c.selectedCountryOrigin(code.code);
      },
      initialSelection: initialSelection,
      showFlag: true,
      hideSearch: true,
      textStyle: typo.bold,
      flagWidth: 20,
      barrierColor: appColors.trans,
      headerText: "Select Country Code",
      headerTextStyle: typo.get13.w500,
      boxDecoration: BoxDecoration(
          color: appColors.dialogBG, borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      favorite: ["IN", "US", "GB", "CA", "AU"],
      comparator: (a, b) => b.name!.compareTo(a.name!),
      builder: (v) {
        return SizedBox(
            width: 60.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                    child: Text(
                  v?.dialCode ?? "",
                  style: typo.bold,
                )),
                Icon(Icons.arrow_drop_down_outlined)
              ],
            ));
      },
      onInit: (code) {
        c.selectedCountryCode(code?.dialCode);
        c.selectedCountryOrigin(code?.code);
      },
    );
  }
}
