import 'package:flutter/material.dart';
import 'package:provider_starter_app/theme/theme.dart';

class ThemeViewModel extends ChangeNotifier {
  bool isLightTheme;

  ThemeViewModel({this.isLightTheme = true});

  ThemeData get getThemeData =>
      isLightTheme ? lightTheme : darkTheme;

  set setThemeData(bool val) {
    if (val) {
      isLightTheme = true;
    } else {
      isLightTheme = false;
    }
    notifyListeners();
  }
}
