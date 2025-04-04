import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:localization_helper/ai_services/ai_service.dart';
import 'package:localization_helper/config/app_theme.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/providers/theme_provider.dart';
import 'package:localization_helper/screens/home/home.dart';
import 'package:localization_helper/widgets/scrolling.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Translate.init(defaultLangCode: "ar",);
  await Shared.init();
  
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create:(_)=> ThemeProvider()),
      ChangeNotifierProvider(create: (_) => Localization()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    AIService.init(context);
    return 
         Builder(builder: (context) {
          bool isDarkMode = context.watch<ThemeProvider>().darkMode;
          MaterialColor accentColor =  kAccentColor;
          return 
          ToastificationWrapper(
          child :GlobalLoaderOverlay(
            child: MaterialApp(
                scrollBehavior: MyCustomScrollBehavior(),
                title: 'Achievement Box',
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                theme: buildTheme(accentColor, isDarkMode),
                home:   const Home()),
          ));
        });
  }
}