import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static String lastShownNumber = 'lastShownNumber';
  static String adId = 'adId';
}

class PreferenceHelper {
  static final PreferenceHelper instance = PreferenceHelper._internal();
  factory PreferenceHelper() {
    return instance;
  }

  PreferenceHelper._internal();

  static SharedPreferences? preferences;
  createSharedPref() {
    SharedPreferences.getInstance().then((pref) {
      PreferenceHelper.preferences = pref;
    });
  }

  setData(String key, dynamic value) {
    if (PreferenceHelper.preferences != null) {
      if (value is String) {
        PreferenceHelper.preferences!.setString(key, value);
      } else if (value is int) {
        PreferenceHelper.preferences!.setInt(key, value);
      } else if (value is double) {
        PreferenceHelper.preferences!.setDouble(key, value);
      } else if (value is bool) {
        PreferenceHelper.preferences!.setBool(key, value);
      } else if (value is List<String>) {
        PreferenceHelper.preferences!.setStringList(key, value);
      } else {
        PreferenceHelper.preferences!.setString(key, value);
      }
    } else {
      SharedPreferences.getInstance().then((pref) {
        PreferenceHelper.preferences = pref;
        if (value is String) {
          PreferenceHelper.preferences!.setString(key, value);
        } else if (value is int) {
          PreferenceHelper.preferences!.setInt(key, value);
        } else if (value is double) {
          PreferenceHelper.preferences!.setDouble(key, value);
        } else if (value is bool) {
          PreferenceHelper.preferences!.setBool(key, value);
        } else if (value is List<String>) {
          PreferenceHelper.preferences!.setStringList(key, value);
        } else {
          PreferenceHelper.preferences!.setString(key, value);
        }
      });
    }
  }

  Future<dynamic> getData(String key) async {
    if (preferences == null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      PreferenceHelper.preferences = pref;
      return preferences!.get(key);
    } else {
      return preferences!.get(key);
    }
  }

  void clearData() {
    if (PreferenceHelper.preferences == null) {
      SharedPreferences.getInstance().then((value) {
        value.clear();
      });
    }
  }

  Future<void> setStringList() async {
    await setStringList();
  }
}
