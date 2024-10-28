import 'package:flutter/material.dart';
import 'package:localization_helper/controller/prefs.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider() {
    _darkMode = Shared.prefs.getBool("isDarkMode")??false;
  }


  toggleMode() async{
    _darkMode = !_darkMode;
    Shared.prefs.setBool("isDarkMode", _darkMode);
    notifyListeners();
  }


  late bool _darkMode;
  get darkMode => _darkMode;
}