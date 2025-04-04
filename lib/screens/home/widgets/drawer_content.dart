import 'package:asset_icon/asset_icon.dart';
import 'package:flutter/material.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_helper/general_widgets/PrimaryContainer.dart';
import 'package:localization_helper/general_widgets/imageIcon.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/screens/home/widgets/lang_tile.dart';
import 'package:localization_helper/screens/home/widgets/localization_dialog.dart';
import 'package:localization_helper/screens/settings/settings.dart';
import 'package:provider/provider.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({super.key});

  @override
  _DrawerContentState createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  String? selectedLangCode;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      borderRadius: 0,
      margin: 0,
      padding: 8,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: AssetIcon("settings.png"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                },
              ),
              const Expanded(child: SizedBox()),
              IconButton(
                icon: AssetIcon("folder.svg"),
                onPressed: () {
                  openFolder(context);
                },
              ),
              IconButton(
                icon: AssetIcon("save.svg"),
                onPressed: () {
                  saveData(context);
                },
              ),
              IconButton(
                icon: AssetIcon("add.svg", size: 20),
                onPressed: () {
                  showLangDialog(context);
                },
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Column(
                  children: generateLangsTiles(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> generateLangsTiles(BuildContext context) {
    List<Widget> langTiles = [];
    for (var langCode in context.watch<Localization>().languages()) {
      langTiles.add(
        LangTile(
          langCode: langCode,
          isSelected: langCode == selectedLangCode, // Check if selected
          onTap: () {
            setState(() {
              if(selectedLangCode != langCode){
              selectedLangCode = langCode; }
              else{
                selectedLangCode = null;
              }
              context
                .read<Localization>()
                .dataManager
                .filterByLang(selectedLangCode??"");
            context.read<Localization>().notify();
            // print(context.read<Localization>().dataManager.filteredData);
            });
          },
        ),
      );
    }
    return langTiles;
  }
}
