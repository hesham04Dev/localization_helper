import 'package:asset_icon/asset_icon.dart';
import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_helper/general_widgets/PrimaryContainer.dart';
import 'package:localization_helper/general_widgets/imageIcon.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/screens/home/widgets/localization_dialog.dart';
import 'package:localization_helper/screens/home/widgets/search_field.dart';
import 'package:localization_helper/widgets/key_card.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';

import '../../../generated/icons.g.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    var localization = context.read<Localization>();
    var horizontalController = ScrollController();
    var mediaQuery = MediaQuery.sizeOf(
      context,
    ); //this to update the screen when size changes
    var keys = context.watch<Localization>().dataManager.keys(filtered: true);
    // print(keys.length);
    // print("my keys");
    var languages = context.watch<Localization>().dataManager.languages(
      filtered: true,
    );

    // print(keys);
    // print(languages);
    double getMinWidth() {
      var totalWidth = mediaQuery.width;
      var availableWidth = totalWidth;
      if (totalWidth > kLargeScreenWidth) {
        availableWidth -= kDrawerWidth;
      }
      if (availableWidth > 0) return availableWidth;
      return 0;
    }

    var minCardWidth = getMinWidth();
    String? langFilter =
        context.read<Localization>().dataManager.filters["langFilter"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          // refresh the home if the size of screen changed to show the menu or hide it
          leading:langFilter?.isNotEmpty ?? false ? IconButton(onPressed: (){
             context
                .read<Localization>()
                .dataManager
                .filterByLang("");
            context.read<Localization>().notify();
          }, icon: AssetIcon(AssetIcons.refresh)):SizedBox(),
          title: Text(tr("home")),
          actions: [
            
            SearchField(),
            if (langFilter?.isNotEmpty ?? false)
              IconButton(
                onPressed: () {
                  context.read<Localization>().generateLangValues(langFilter!);
                },
                icon: AssetIcon(AssetIcons.magic),
              ),
            IconButton(
              icon: AssetIcon("add.svg", size: 25),
              onPressed: () {
                showKeyDialog(context);
              },
            ),
          ],
        ),
        SizedBox(
          width: getMinWidth(),
          child: PrimaryContainer(
            // borderRadius: 5,
            margin: 2,
            padding: 1,
            child: Row(
              children: [
                //  localization
                //               .homeController.text != ""?IconButton(onPressed: (){
                //                 localization.homeController.text = "";
                //               localization.homeControllerData = {};
                //               }, icon: AssetIcon(AssetIcons.close,size:20)):SizedBox(),
                Expanded(
                  child: TextField(
                    focusNode: context.read<Localization>().homeFocusNode,
                    controller: context.read<Localization>().homeController,
                    onChanged: (value) {
                      localization.dataManager.data[localization
                              .homeControllerData["lang"]]?[localization
                                  .homeControllerData["key"] ??
                              ""] =
                          value;
                      localization.notify();
                    },
                    onSubmitted: (_) {
                      localization.homeController.text = "";
                      localization.homeControllerData = {};
                    },
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Scrollbar(
          thumbVisibility: true,
          controller: horizontalController,
          child: SingleChildScrollView(
            controller: horizontalController,
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryContainer(
                  paddingHorizontal: 20,
                  borderRadius: 0,
                  constraints: BoxConstraints(minWidth: minCardWidth),
                  margin: 0,
                  child: Row(
                    children: [
                      SizedBox(width: kLanguageWidth, child: Text(tr("key"))),
                      ...List.generate(
                        languages.length,
                        (index) => SizedBox(
                          width: kLanguageWidth,
                          child: Text(languages[index]),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height - 150,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(keys.length, (index) {
                        return KeyCard(
                          minWidth: minCardWidth,
                          localizationKey:
                              keys[reverseIndex(
                                listLength: keys.length,
                                index: index,
                              )],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
