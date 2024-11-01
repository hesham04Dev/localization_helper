import 'package:flutter/material.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';

import '../../../providers/localization.dart';

class LocalizationDialog extends StatelessWidget {
  final Function(String input) saveClick;
  final Function(String input) generateClick;
  final String hintText;
  final bool isAutoGenerate;
  const LocalizationDialog(
      {super.key,
      required this.hintText,
      required this.saveClick,
      required this.generateClick,
      this.isAutoGenerate = false});

  @override
  Widget build(BuildContext context) {
    String input = "";

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width: 250,
                child: TextField(
                  onChanged: (value) => input = value,
                  autofocus: true,
                  onSubmitted: (val) {
                    isAutoGenerate ? generateClick(input) : saveClick(input);
                    Navigator.pop(context);
                  },
                  decoration: InputDecoration(hintText: hintText),
                )),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: () {
                      saveClick(input);
                      Navigator.pop(context);
                    },
                    child: Text(tr("save"))),
                FilledButton(
                    onPressed: () async {
                      await generateClick(input);
                      Navigator.pop(context);
                    },
                    child: Text(tr("generate")))
              ],
            )
          ],
        ),
      ),
    );
  }
}

showLangDialog(context) {
  showDialog(
    context: context,
    
    builder: (context) => LocalizationDialog(
      isAutoGenerate: Shared.prefs.getBool("autoGenerateOnLang")??false,
      hintText: tr("langCode"),
      saveClick: (String input) {
        context.read<Localization>().addLang(input);
      },
      generateClick: (String input) {
        context.read<Localization>().generateLangValues(input);
         context.read<Localization>().showTost(context);
        context.read<Localization>().notify();
      },
    ),
  );
}

showKeyDialog(context) {
  showDialog(
    context: context,
    builder: (context) => LocalizationDialog(
      isAutoGenerate: Shared.prefs.getBool("autoGenerateOnKey")??false,
      hintText: tr("key"),
      saveClick: (String input) {
        context.read<Localization>().addKey(input);
      },
      generateClick: (String input) {
        context.read<Localization>().generateKeyValues(input);
        context.read<Localization>().showTost(context);
        context.read<Localization>().notify();
      },
    ),
  );
}
