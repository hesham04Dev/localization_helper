import 'package:flutter/material.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/general_widgets/PrimaryContainer.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';

class KeyPage extends StatefulWidget {
  final String localizationKey;
  const KeyPage({super.key, required this.localizationKey});

  @override
  State<KeyPage> createState() => _KeyPageState();
}

class _KeyPageState extends State<KeyPage> {
  @override
  Widget build(BuildContext context) {
    var localizationInstance = context.read<Localization>();
    var langs = localizationInstance.languages();
    var keyValues = localizationInstance.dataManager.getKeyValues(widget.localizationKey);
    List controllers = List.generate(
      langs.length,
      (index) => TextEditingController(text: keyValues[index]),
    );

   generateKeyCard() async{
    var param = {"key": widget.localizationKey};
    for (int i = 0; i < controllers.length; i++) {
         param[langs[i]] = controllers[i].text;
      }
     await localizationInstance.generateCardValues(param);
     final data = localizationInstance.dataManager.data;
     for (int i = 0; i < controllers.length; i++) {
         controllers[i].text = data[langs[i]]?[widget.localizationKey];
      }
    setState(() {
      
    });
    
  }

    return Scaffold(
        appBar: AppBar(
          title: Text("${tr("key")}: ${widget.localizationKey}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => PrimaryContainer(
                          margin: 2,
                          paddingHorizontal: 20,
                          padding: 5,
                          child: TextField(
                                controller: controllers[index],
                                onSubmitted: Shared.prefs.getBool("autoGenerateOnCard")??false ? (c){generateKeyCard();}:null,
                                decoration: InputDecoration(hintText: langs[index]),
                              ),
                        ),
                        itemCount: keyValues.length,
                ),
              ),
              Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child:
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          TextButton(
                              onPressed: () {
                                for (int i = 0; i < controllers.length; i++) {
                                  localizationInstance.
                                          dataManager.data[langs[i]]![widget.localizationKey] =
                                      controllers[i].text;
                                }
                                Navigator.pop(context);
                                // print(localizationInstance.data);
                              },
                              child: Text(tr("save"))),
                          FilledButton(
                              onPressed: () 
                                {generateKeyCard();
                              },
                              child: Text(tr("generate")))
                        ]))
            ],
          ),
        ));
  }
}
