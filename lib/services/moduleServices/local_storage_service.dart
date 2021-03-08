import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  /// Contains [bool] value about onboarding screen visited
  static const String ONBOARDING_KEY = 'onboarding flag';
  static const String AIRPORT_KEY = "airport";

  /// Sets the value of onboarding screen [visited]
  ///
  /// defaults to true
  Future<void> markOnBoardingAsVisited({bool visited = true}) async {
    assert(visited != null);
    await _preferences.setBool(ONBOARDING_KEY, visited);
  }

  /// returns true if onBoarding screen is visited
  bool checkIfOnBoardingVisited() {
    try {
      return _preferences.getBool(ONBOARDING_KEY) ?? false;
    } catch (e) {
      return false;
    }
  }
}
