import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_helper/screens/home/intents/intents.dart';
import 'package:localization_helper/screens/home/widgets/localization_dialog.dart';

class ShortcutsLayer extends StatelessWidget {
  final Widget child;
  const ShortcutsLayer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // context.read<Localization>().fromJson("assets/localization/");
        return Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift, LogicalKeyboardKey.keyN): LangDialogIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN): KeyDialogIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): SaveDialogIntent(),
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
                
                 openFolder(context);
                return null; // Ensure to return null
              }),
              SearchIntent: CallbackAction(onInvoke: (intent) {
                // Implement your search dialog or functionality
                return null; // Ensure to return null
              }),
              SaveDialogIntent: CallbackAction(onInvoke: (intent) {
                saveData(context);
                return null; // Ensure to return null
              })
            },
            child: Focus(
              autofocus: true, // Ensure the Focus widget can capture keyboard input
              child: child
            ),
          ),
        );
  }
}