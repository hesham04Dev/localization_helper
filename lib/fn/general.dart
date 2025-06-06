import 'package:asset_icon/asset_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/controller/shortcuts_controller.dart';
import 'package:localization_helper/generated/icons.g.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/screens/home/widgets/shortcuts.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

saveData(BuildContext context) {
  context.read<Localization>().saveToJson();
}

Future<void> openFolder(BuildContext context) async {
  var result = await FilePicker.platform.getDirectoryPath();
  if (result != null && result.isNotEmpty) {
    context.read<Localization>().fileManager.path = result;
    context.read<Localization>().loadFromJson();
    
  }
  //  shortcutsFocus.requestFocus();
}

Future goToWithReplacement(BuildContext context, WidgetBuilder builder) async {
  return await Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: builder),
  );
}

Future goTo(BuildContext context, WidgetBuilder builder) async {
  return await Navigator.push(context, MaterialPageRoute(builder: builder));
}

int reverseIndex({required int listLength, required int index}) {
  return listLength - index - 1;
}

String defaultLang() {
  return Shared.prefs.getString("defaultLang") ?? kDefaultLang;
}

showSearchDialog(BuildContext context) async {
  // await Future.delayed(Duration(seconds: 1));
  var searchText = "";
  submit() {
    context.read<Localization>().dataManager.filterByKey(searchText);
    context.read<Localization>().notify();
    Navigator.pop(context);
  }

  showDialog(
    context: context,
    builder:
        (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    onChanged: (value) {
                      searchText = value;
                    },
                    onFieldSubmitted: (value) {
                      // print(value);
                      submit();
                    },
                    decoration: InputDecoration(hintText: tr("key")),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    submit();
                  },
                  icon: AssetIcon(AssetIcons.search),
                ),
              ],
            ),
          ),
        ),
  );
}

 errorToast(String message) {
  toastification.show(
    title: Text(message),
    autoCloseDuration: const Duration(seconds: 3),
    type: ToastificationType.error,
  );
}
