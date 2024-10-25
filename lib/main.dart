

import 'package:flutter/material.dart';
import 'package:localization_helper/config/app_theme.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/screens/home/home.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Translate.init(defaultLangCode: "ar");
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Localization()),
      
      //ChangeNotifierProvider(create: (_) => SearchProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return 
         Builder(builder: (context) {
          bool isDarkMode = !!true;
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

//using 2d scrollable
//add shortcuts
//ctr n to new key 
// ctrl shift n to new lang
// ctrl s to save 
// ctrl o to open
// ctrl i to settings
// ctrl q to search
// use something rather than list tile in drawer
