import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/user_number_model.dart';
import '../../reusable/globle.dart';
import '../../uttils/local_db/sql_helper.dart';

class RedirectController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final dbHelper = DbHelper.instance;
  RxBool loading = false.obs;
  RxList<UserNumber> userNumberList = <UserNumber>[].obs;
  RxInt selectedCategory = 0.obs;
  @override
  void onInit() {
    getUserNumber();
    super.onInit();
  }

  List<String> filterList = ["All", "Saved", "Unsaved"];

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  Future<void> launchWhatsApp(String phoneNumber,
      {bool saveOnDB = true}) async {
    var androidUrl = "whatsapp://send?phone=+91$phoneNumber&text=";

    try {
      await launchUrl(Uri.parse(androidUrl));
      if (saveOnDB) {
        if (phoneNumber.isNotEmpty) {
          await saveUserNumberToDB(phoneNumber);
          getUserNumber();
        }
      }

      phoneController.clear();
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<void> getUserNumber() async {
    loading(true);

    var userdata = await dbHelper.queryAll("USER_NUMBER");
    String userdataJson = jsonEncode(userdata);
    List<UserNumber> userList = userNumberFromJson(userdataJson);
    userNumberList.value = userList;
    userNumberList.sort((a, b) {
      DateTime? dateA = a.createdAt;
      DateTime? dateB = b.createdAt;
      return dateA!.compareTo(dateB!);
    });
    userNumberList.value = userNumberList.reversed.toList();

    loading(false);
  }

  Future<void> saveUserNumberToDB(String number) async {
    Map<String, dynamic> row = {
      "CreatedAt": DateTime.now().toString(),
      "Number": number,
    };
    dbHelper.insert("USER_NUMBER", row);
  }
}
