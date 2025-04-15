import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization_helper/controller/shortcuts_controller.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_helper/screens/home/intents/intents.dart';
import 'package:localization_helper/screens/home/widgets/localization_dialog.dart';
import 'package:localization_helper/screens/settings/settings.dart';
import 'package:provider/provider.dart';

// var shortcutsFocus = FocusNode();

class ShortcutsLayer extends StatelessWidget {
  final Widget child;
  const ShortcutsLayer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // context.read<Localization>().fromJson("assets/localization/");
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift,
            LogicalKeyboardKey.keyN): LangDialogIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
            KeyDialogIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            SaveDialogIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyO):
            FolderDialogIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI):
            SettingIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyQ):
            SearchIntent(),
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
            goTo(context, (context) => Settings(),);
            return null; // Ensure to return null
          }),
          // This stopped since it makes errors when used
          // FolderDialogIntent: CallbackAction(onInvoke: (intent) async{
          //   await openFolder(context);
          //   return null; // Ensure to return null
          // }),
          SearchIntent: CallbackAction(onInvoke: (intent) {
             showSearchDialog(context);
            return null; // Ensure to return null
          }),
          // This stopped since it makes errors when used
          // SaveDialogIntent: CallbackAction(onInvoke: (intent) {
          //   saveData(context);
          //   return null; // Ensure to return null
          // })
        },
        child: Focus(
          focusNode: context.read<ShortcutsController>().focusNode,
            autofocus:
                true, // Ensure the Focus widget can capture keyboard input
              // canRequestFocus: true,
              // focusNode: shortcutsFocus,           
            child: child),
      ),
    );
  }
}
