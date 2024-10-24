import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/screens/home/intents/intents.dart';
import 'package:localization_helper/screens/home/widgets/drawer_content.dart';
import 'package:localization_helper/screens/home/widgets/home_body.dart';
import 'package:localization_helper/screens/home/widgets/localization_dialog.dart';
import 'package:localization_lite/translate.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isLargeScreen = constraints.maxWidth >= kLargeScreenWidth;

        return Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift, LogicalKeyboardKey.keyN): LangDialogIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN): KeyDialogIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyO): FolderDialogIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI): SettingIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyQ): SearchIntent(),
          },
          child: Actions(
            actions: {
              LangDialogIntent: CallbackAction(onInvoke: (intent) {
                showLangDialog(context);
                return null; // Ensure to return null
              }),
              KeyDialogIntent: CallbackAction(onInvoke: (intent) {
                showKeyDialog(context);
                return null; // Ensure to return null
              }),
              SettingIntent: CallbackAction(onInvoke: (intent) {
                // Implement your setting dialog or functionality
                return null; // Ensure to return null
              }),
              FolderDialogIntent: CallbackAction(onInvoke: (intent) {
                // Implement your folder dialog or functionality
                return null; // Ensure to return null
              }),
              SearchIntent: CallbackAction(onInvoke: (intent) {
                // Implement your search dialog or functionality
                return null; // Ensure to return null
              }),
            },
            child: Focus(
              autofocus: true, // Ensure the Focus widget can capture keyboard input
              child: Scaffold(
                drawer: isLargeScreen ? null : const Drawer(
                  child: DrawerContent(),
                ),
                body: Row(
                  children: [
                    if (isLargeScreen)
                      const SizedBox(
                        width: kDrawerWidth,
                        child: DrawerContent(),
                      ),
                    const Expanded(
                      child: HomeBody(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
