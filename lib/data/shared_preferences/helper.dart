import 'dart:async';

import 'package:lttechapp/data/shared_preferences/preferences.dart';

class SharedPreferenceHelper {
  // General Methods: ----------------------------------------------------------
  static Future isTimesheetcreated(bool iscreated) async {
    await Preference.setBool(PrefKeys.istimesheetcreated, iscreated);
  }



  static Future<bool> get getTimesheetcreated =>
      Preference.getBool(PrefKeys.istimesheetcreated);

  static Future saveAuthToken(String value) =>
      Preference.setString(PrefKeys.authToken, value);
  static Future<String> get authToken =>
      Preference.getString(PrefKeys.authToken);

  static Future saveRefreshToken(String value) =>
      Preference.setString(PrefKeys.refreshToken, value);
  static Future<String> get refreshToken =>
      Preference.getString(PrefKeys.refreshToken);

  static Future saveIsLoggedIn(bool value) =>
      Preference.setBool(PrefKeys.isLoggedIn, value);
  static Future<bool> get isLoggedIn => Preference.getBool(PrefKeys.isLoggedIn);

  static Future saveIsremember(bool value) =>
      Preference.setBool(PrefKeys.isrememberme, value);

  static Future<bool> get isRemberme => Preference.getBool(PrefKeys.isrememberme);

  static Future saveusername(String username) => Preference.setString(PrefKeys.username, username);

  static Future<String> get username => Preference.getString(PrefKeys.username);

  static Future saveuserpwd(String pwd) => Preference.setString(PrefKeys.password, pwd);

  static Future<String> get userpwd => Preference.getString(PrefKeys.password);

  static Future savecreatedtimesheetid(String timesheetid) => Preference.setString(PrefKeys.savecreatedtimesheetid, timesheetid);

  static Future<String> get createdtimesheetid => Preference.getString(PrefKeys.savecreatedtimesheetid);



  static Future<void> clear() async {
    await Future.wait(<Future>[
      saveIsLoggedIn(false),
      saveAuthToken(''),
      saveRefreshToken(''),

    ]);
  }

  // General Methods: ----------------------------------------------------------
  // Future<void> saveAuthToken(String authToken) async {
  //   await _sharedPreference.setString(PrefKeys.authToken, authToken);
  // }

  // Future<String> get authToken {
  //   return Preference.getString(PrefKeys.authToken);
  // }

  // Future<bool> removeAuthToken() async {
  //   return _sharedPreference.remove(PrefKeys.authToken);
  // }

  // Future<void> saveIsLoggedIn(bool value) async {
  //   await _sharedPreference.setBool(PrefKeys.isLoggedIn, value);
  // }

  // bool get isLoggedIn {
  //   return _sharedPreference.getBool(PrefKeys.isLoggedIn) ?? false;
  // }

  // bool get gettimesheetcreated {
  //   return _sharedPreference.getBool(PrefKeys.istimesheetcreated) ?? false;
  // }

  // Future<void> clear() async {
  //   await _sharedPreference.clear();
  // }
}

mixin PrefKeys {
  static const String isLoggedIn = "isLoggedIn";
  static const String authToken = "authToken";
  static const String refreshToken = "refreshToken";
  static const String istimesheetcreated = "istimesheetcreated";
  static const String isrememberme = "isrememberme";
  static const String username = "username";
  static const String password = "password";
  static const String savecreatedtimesheetid = "savecreatedtimesheetid";
}
