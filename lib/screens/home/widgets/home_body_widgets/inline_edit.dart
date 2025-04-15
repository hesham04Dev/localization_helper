import 'package:flutter/material.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/widgets/verification_box.dart';
import 'package:provider/provider.dart';

import '../../../../controller/shortcuts_controller.dart';
import '../../../../general_widgets/PrimaryContainer.dart';
import '../autoDirectionTextField.dart';

class InlineEdit extends StatelessWidget {
  final double width;
  const InlineEdit({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    var localization = context.watch<Localization>();
    return localization.homeControllerData.isEmpty
        ? SizedBox(height: 34)
        : SizedBox(
          width: width,
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
                  child: AutoDirectionTextField(
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
                      context
                          .read<ShortcutsController>()
                          .focusNode
                          .requestFocus();
                      localization.notify();
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
                VerificationBox(langCode:localization.homeControllerData["lang"]??"" ,translationKey: localization.homeControllerData["key"]??"",)
              ],
            ),
          ),
        );
  }
}
