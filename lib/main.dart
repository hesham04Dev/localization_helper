

import 'package:flutter/material.dart';
import 'package:localization_helper/config/app_theme.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controllers/localization.dart';
import 'package:localization_helper/screens/home/home.dart';
import 'package:localization_lite/translate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Translate.init(defaultLangCode: "ar");
   Localization.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return 
         Builder(builder: (context) {
          bool isDarkMode = false;
          MaterialColor accentColor =  kAccentColor;
          return MaterialApp(
              title: 'Achievement Box',
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              theme: buildTheme(accentColor, isDarkMode),
              home:  const Home());
        });
  }
}

