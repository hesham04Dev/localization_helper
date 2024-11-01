import 'package:flutter/material.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';


class UpdateDeleteDialog extends StatelessWidget {
  final Function(String input) updateClick;
  final Function(String input) deleteClick;
  final String hintText;
  final String deleteText;
  const UpdateDeleteDialog(
      {super.key,
      required this.hintText,
      required this.updateClick,
      required this.deleteClick,
      required this.deleteText
      });

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
                    updateClick(val);
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
                    onPressed: () async {
                      await updateClick(input);
                      Navigator.pop(context);
                    },
                    child: Text(tr("save"))),
                FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red)
                    ),
                    onPressed: () async {
                      await deleteClick(input);
                      Navigator.pop(context);
                    },
                    child: Text("${tr("delete")} $deleteText"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

showUpdateDeleteLangDialog(context,{required oldCode}) {
  showDialog(
    context: context,
    
    builder: (context) => UpdateDeleteDialog(
      deleteText: oldCode,
      hintText: "${tr("update")} ${tr("LangCode")}",
      updateClick: (String input) {
        context.read<Localization>().updateLang(newCode: input,oldCode: oldCode);
      },
      deleteClick: (String input) {
        context.read<Localization>().deleteLang(input);
      },
    ),
  );
}

showUpdateDeleteKeyDialog(context,{required oldKey}) {
  showDialog(
    context: context,
    builder: (context) => UpdateDeleteDialog(
      deleteText: oldKey,
      hintText: "${tr("update")} ${tr("key")}",
      updateClick: (String input) {
        context.read<Localization>().updateKey(newKey: input,oldKey: oldKey);
      },
      deleteClick: (String input) {
        context.read<Localization>().deleteKey(oldKey);

      },
    ),
  );
}
