import 'package:asset_icon/asset_icon.dart';
import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/general_widgets/click_detector.dart';
import 'package:localization_helper/general_widgets/imageIcon.dart';
import 'package:localization_helper/generated/icons.g.dart';
import 'package:localization_helper/screens/home/widgets/update_delete_dialog.dart';

class LangTile extends StatelessWidget {
  const LangTile({
    super.key,
    required this.langCode,
    required this.isSelected,
    required this.onTap,
  });

  final String langCode;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClickDetector(
      onRightClick: () {
        openEditDialog(context, langCode);
      },
      child: ListTile(
        leading: AssetIcon( AssetIcons.file),
        title: Text("$langCode.json"),
        tileColor: isSelected ? kAccentColor.withOpacity(0.2) : null, // Highlight if selected
        onTap: onTap, // Call the onTap function from DrawerContent
        onLongPress: () {
          openEditDialog(context, langCode);
        },
      ),
    );
  }

  void openEditDialog(BuildContext context, String langCode) {
    var defaultLang = Shared.prefs.getString("defaultLang") ?? kDefaultLang;

    if (langCode != defaultLang) {
      showUpdateDeleteLangDialog(context, oldCode: langCode);
    }
  }
}
