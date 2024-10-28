

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localization_helper/ai_services/gemini.dart';
import 'package:localization_helper/config/app_theme.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/providers/theme_provider.dart';
import 'package:localization_helper/screens/home/home.dart';
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
              title: 'Achievement Box',
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              theme: buildTheme(accentColor, isDarkMode),
              home:  Home());
        });
  }
}

//using 2d scrollablev TODO 


//add shortcuts done
//ctr n to new key done
// ctrl shift n to new lang done
// ctrl s to save done
// ctrl o to open done
// ctrl i to settings done
// ctrl q to search done 


// todo why shortcuts stops sometimes
 
// ADD title in home body

// onclick on a lang show onlys the values of it
// add ai btn to fill all its keys

// make search works
// works on the settings done
// save the data in the settings 
// add on deafult on lang dialog 
// add default on Key dialog
// add default on key_Card
// add dark mode in settings
// add btn on lang to regenerate 


// on right click on lang or card show update name or delete
// show something on empty

// change the app color to a olive or somthing like 
// we need to have a lang before adding keys
// no generate if thers is no lang
//maybe add a default lang in the settings !important
// if no api key then in the generate btn show alert add api key to enable this feature
//handle the ai err and show alert with the err message and remove the added data
//add Darkmode provider done



