import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/local.dart';
import '../../model/user_number_model.dart';
import '../../reusable/globle.dart';
import '../../uttils/local_db/sql_helper.dart';

class RedirectController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  RxList<UserNumber> userNumberList = <UserNumber>[].obs;
  RxList<UserNumber> filteredUserNumberList = <UserNumber>[].obs;
  final dbHelper = DbHelper.instance;
  RxBool loading = false.obs;
  RxInt selectedCategory = 0.obs;
  RxBool permissionDenied = false.obs;

  List<String> filterList = ["All", "Saved", "Unsaved"];

  @override
  void onInit() {
    super.onInit();
    filteredUserNumberList.value = userNumberList;
  }

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

  Future<void> launchWhatsApp(String phoneNumber,
      {bool saveOnDB = true}) async {
    if (phoneNumber.startsWith('+91')) {
      phoneNumber = phoneNumber.substring(3);
    } else if (phoneNumber.startsWith('91')) {
      phoneNumber = phoneNumber.substring(2);
    }
    var androidUrl = "whatsapp://send?phone=+91$phoneNumber&text=Hi";

    try {
      await launchUrl(Uri.parse(androidUrl));
      if (saveOnDB) {
        if (phoneNumber.isNotEmpty) {
          await saveUserNumberToDB(phoneNumber);
          await getUserNumber();
        }
      }
      phoneController.clear();
    } catch (e) {
      showToast(e.toString());
    }
  }

  saveNumber(String phoneNumber) async {
    if (phoneNumber.isNotEmpty) {
      await saveUserNumberToDB(phoneNumber);
      await getUserNumber();
    }
  }

  Future<void> launchPhoneDial(String phoneNumber) async {
    // Check if phone number starts with +91 or 91, remove the country code
    if (phoneNumber.startsWith('+91')) {
      phoneNumber = phoneNumber.substring(3);
    } else if (phoneNumber.startsWith('91')) {
      phoneNumber = phoneNumber.substring(2);
    }

    var phoneDialUrl = "tel:+91$phoneNumber";

    try {
      // Launch the phone dialer
      await launchUrl(Uri.parse(phoneDialUrl));
    } catch (e) {
      showToast(e.toString()); // Handle errors
    }
  }

  Future<void> launchSMS(String phoneNumber, {String message = 'Hi'}) async {
    // Check if phone number starts with +91 or 91, remove the country code
    if (phoneNumber.startsWith('+91')) {
      phoneNumber = phoneNumber.substring(3);
    } else if (phoneNumber.startsWith('91')) {
      phoneNumber = phoneNumber.substring(2);
    }

    var smsUrl = "sms:+91$phoneNumber?body=$message";

    try {
      // Launch the SMS app
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

  Future<void> saveUserNumberToDB(String number) async {
    Map<String, dynamic> row = {
      "CreatedAt": DateTime.now().toString(),
      "Number": number,
    };
    await dbHelper.insert("USER_NUMBER", row);
  }
}
