

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localization_helper/ai_services/gemini.dart';
import 'package:localization_helper/config/app_theme.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/providers/theme_provider.dart';
import 'package:localization_helper/screens/home/home.dart';
import 'package:localization_helper/widgets/scrolling.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await GeminiService().getKeyValues({"key":"home","en":"","ar":"","hi":""});
  // await GeminiService().getLangValues({"en":{"home":"Home","menu":"Menu","status":"Status","hi":"Hi"},"ar":{"home":"","menu":"","status":"","hi":""}});
  await Translate.init(defaultLangCode: "ar");
  await Shared.init();
  GeminiService.init();
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create:(_)=> ThemeProvider()),
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
          bool isDarkMode = context.watch<ThemeProvider>().darkMode;
          MaterialColor accentColor =  kAccentColor;
          return MaterialApp(
              scrollBehavior: MyCustomScrollBehavior(),
              title: 'Achievement Box',
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              theme: buildTheme(accentColor, isDarkMode),
              home:  const Home());
        });
  }
}



// todo why shortcuts stops sometimes
 

// onclick on a lang show onlys the values of it
// add ai btn to fill all its keys TODO

// make search works TODO 
// add btn on lang to regenerate  TODO


// on right click on lang or card show update name or delete TODO
// show something on empty TODO 

// change the app color to a olive or somthing like TODO
// update the app icons
// change the shape of the settings and the keypage
// show alerts for errors and sucsses


// if no api key then in the generate btn show alert add api key to enable this feature
//handle the ai err and show alert with the err message and remove the added data

// lang clicking page , shortcuts err ,search,

//prevent the renaming and deleting the default lang

// add online json files 
// add direction if ar or en see the easy localization 
// export not found key to a file in localization lite

