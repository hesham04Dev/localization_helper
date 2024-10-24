import 'package:flutter/material.dart';
import 'package:localization_lite/translate.dart';

 class LocalizationDialog extends StatelessWidget {
  final saveClick;
  final generateClick;
  const LocalizationDialog({super.key, required this.saveClick, required this.generateClick} );

  @override
  Widget build(BuildContext context) {
    String LangCode = "";

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width: 250,
                child: TextField(
                  onChanged: (value) => LangCode = value,
                  autofocus: true,
                  onSubmitted: (val) {
                    saveClick();
                    Navigator.pop(context);
                  },
                  decoration: const InputDecoration(hintText: "Lang code"),
                )),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: () {
                      saveClick();
                      // context.read<Localization>().addLang(LangCode);
                      Navigator.pop(context);
                    },
                    child: Text(tr("save"))),
                FilledButton(onPressed: () async{
                 await generateClick();
                 Navigator.pop(context); 
                }, child: Text(tr("generate")))
              ],
            )
          ],
        ),
      ),
    );
  }
}
