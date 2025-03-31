import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/local.dart';
import '../model/user_number_model.dart';
import '../reusable/globle.dart';
import '../uttils/local_db/sql_helper.dart';

class RedirectController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  RxList<UserNumber> userNumberList = <UserNumber>[].obs;
  RxList<UserNumber> filteredUserNumberList = <UserNumber>[].obs;
  final dbHelper = DbHelper.instance;
  RxBool loading = false.obs;
  RxInt selectedCategory = 0.obs;
  RxString selectedCountryCode = "+91".obs;
  RxString selectedCountryOrigin = "IN".obs;
  RxBool permissionDenied = false.obs;

  List<String> filterList = ["All", "Saved", "Unsaved"];

  @override
  void onInit() {
    super.onInit();
    filteredUserNumberList.value = userNumberList;
  }

  List<String> contactColorHexList = [
    "B5B2D6",
    "8A9ABB",
    "ABB88F",
    "C09A97",
    "A985D6",
    "D8A7D0",
    "E089E0",
    "8DB88C",
    "7BA68E",
    "DBB79E",
    "CF848E",
    "808CAB",
    "A4CBD3",
    "9184A6",
    "E0D8A3",
    "BD7C9F",
    "B078AD",
    "7153A8",
    "6DC470",
    "85B0D6",
    "E0B86A",
    "E5B4B8",
    "E3C3BE",
    "C3DBA0",
    "B6D4DE",
    "E2BFD1",
    "D5C7E5",
    "E0D1BE",
    "C2E5C5",
    "E6C07D",
    "DAA7C5",
    "BFD4E4",
    "A3D1A8",
    "E1B28C",
    "C9C5E6",
    "A2D0C4",
    "E1A3BA",
    "E3ADC8",
    "ADC9E6",
    "A0D1BD",
    "E9C1B6",
    "C7DA85",
    "E5C29F",
    "CCABE0",
    "8AD5D7",
  ];

  @override
  void onClose() {
    searchController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  List<MoreItem> items = [
    MoreItem(
      icon: Icons.refresh,
      title: "Refresh",
    ),
    MoreItem(
      icon: Icons.help_outline,
      title: "Help",
    ),
    MoreItem(
      icon: Icons.exit_to_app,
      title: "Exit",
    ),
  ];

  Future<void> launchWhatsApp(NumberData data, {bool saveOnDB = true}) async {
    var androidUrl = "whatsapp://send?phone=${data.code}${data.number}&text=Hi";

    try {
      await launchUrl(Uri.parse(androidUrl));
      if (saveOnDB) {
        await saveUserNumberToDB(data);
        await getUserNumber();
      }
      phoneController.clear();
    } catch (e) {
      showToast(e.toString());
    }
  }

  saveNumber(NumberData data) async {
    await saveUserNumberToDB(data);
    await getUserNumber();
  }

  Future<void> launchPhoneDial(String phoneNumber) async {
    var phoneDialUrl = "tel:$phoneNumber";

    try {
      await launchUrl(Uri.parse(phoneDialUrl));
    } catch (e) {
      showToast(e.toString()); // Handle errors
    }
  }

  Future<void> launchSMS(String phoneNumber, {String message = 'Hi'}) async {
    var smsUrl = "sms:$phoneNumber?body=$message";
    try {
      await launchUrl(Uri.parse(smsUrl));
    } catch (e) {
      showToast(e.toString()); // Handle errors
    }
  }

  void filterUserList(String query) {
    if (query.isEmpty) {
      filteredUserNumberList.value = getFilteredList();
    } else {
      query = query.toLowerCase();
      filteredUserNumberList.value = getFilteredList().where((user) {
        String name = user.userName?.toLowerCase() ?? '';
        String number = user.number?.toLowerCase() ?? '';
        return name.contains(query) || number.contains(query);
      }).toList();
    }
    update();
  }

  List<UserNumber> getFilteredList() {
    switch (selectedCategory.value) {
      case 1:
        return userNumberList.where((user) => user.isSaved ?? false).toList();
      case 2:
        return userNumberList
            .where((user) => !(user.isSaved ?? false))
            .toList();
      default:
        return userNumberList;
    }
  }

  Future<void> getUserNumber() async {
    loading(true);

    await _fetchAndSortUserNumbers();

    if (!await _requestContactsPermission()) {
      permissionDenied(true);
    } else {
      final contacts = await _fetchContacts();
      _updateUserNumbersWithContacts(contacts);
      filteredUserNumberList.value =
          getFilteredList(); // Update the filtered list
    }

    loading(false);
  }

  void help() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: "coddynet@gmail.com",
    );
    urlLauncher(params);
  }

  Future<void> urlLauncher(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  Future<void> _fetchAndSortUserNumbers() async {
    var userdata = await dbHelper.queryAll("USER_NUMBER");
    String userdataJson = jsonEncode(userdata);
    List<UserNumber> userList = userNumberFromJson(userdataJson);
    userNumberList.value = userList;

    // Sort the list by creation date
    userNumberList.sort((a, b) {
      DateTime? dateA = a.createdAt;
      DateTime? dateB = b.createdAt;
      return dateA!.compareTo(dateB!);
    });
    userNumberList.value = userNumberList.reversed.toList();
  }

  Future<bool> _requestContactsPermission() async {
    return await FlutterContacts.requestPermission(readonly: true);
  }

  Future<List<Contact>> _fetchContacts() async {
    return await FlutterContacts.getContacts(
        withProperties: true, withPhoto: true);
  }

  void _updateUserNumbersWithContacts(List<Contact> contacts) {
    for (var user in userNumberList) {
      bool isSaved = false;

      for (var contact in contacts) {
        for (var phone in contact.phones) {
          String contactNumber = _cleanPhoneNumber(phone.number);
          String userNumber = _cleanPhoneNumber(user.number!);

          if (contactNumber == userNumber) {
            user.isSaved = true;
            user.userName = contact.displayName;
            user.imageUrl = contact.thumbnail;
            isSaved = true;
            break;
          }
        }
        if (isSaved) break;
      }

      if (!isSaved) {
        user.isSaved = false;
        user.userName = "Unknown";
        user.imageUrl = null;
      }
    }
  }

  String _cleanPhoneNumber(String number) {
    String cleanedNumber = number.replaceAll(RegExp(r'\D'), '');
    if (cleanedNumber.length > 10) {
      cleanedNumber = cleanedNumber.substring(cleanedNumber.length - 10);
    }
    return cleanedNumber;
  }

  Future<void> saveUserNumberToDB(NumberData data) async {
    String getRandomColor() {
      final random = Random();
      return contactColorHexList[random.nextInt(contactColorHexList.length)];
    }

    Map<String, dynamic> row = {
      "CreatedAt": DateTime.now().toString(),
      "CountryOrigin": data.origin,
      "CountryCode": data.code,
      "Number": data.number,
      "Color": getRandomColor(),
    };
    await dbHelper.insert("USER_NUMBER", row);
  }
}
