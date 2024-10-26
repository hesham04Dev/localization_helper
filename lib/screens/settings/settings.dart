import 'package:flutter/material.dart';
import 'package:localization_helper/ai_services/gemini.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/models/PrimaryContainer.dart';
import 'package:localization_lite/translate.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  Widget build(BuildContext context) {
    var apiKeyController = TextEditingController();
    var defaultLangController = TextEditingController();
    bool autoGenerateOnKey = Shared.prefs.getBool("autoGenerateOnKey")?? false;
    bool autoGenerateOnLang = Shared.prefs.getBool("autoGenerateOnLang")?? false;
    bool autoGenerateOnCard = Shared.prefs.getBool("autoGenerateOnCard")?? false;
    bool generateMap = Shared.prefs.getBool("generateMap")?? false;
    bool generateConstKeys = Shared.prefs.getBool("generateConstKeys")?? false;
    bool isDarkMode = Shared.prefs.getBool("isDarkMode")?? false;
    saveApiKey() async {
      await Shared.prefs.setString("apiKey", apiKeyController.text);
      //TODO show info saved
    }

    apiKeyController.text = Shared.prefs.getString('apiKey') ?? "";
    defaultLangController.text =
        Shared.prefs.getString("defaultLang") ?? kDefaultLang;
    final Widget aiApiKeyInput = PrimaryContainer(
      paddingHorizontal: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tr("yourApiKey")),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
              width: 200,
              child: TextField(
                controller: apiKeyController,
                decoration: InputDecoration(
                    suffix: IconButton(
                        onPressed: () async {
                          await saveApiKey();
                        },
                        icon: const Icon(Icons.save))),
                obscureText: true,
                onSubmitted: (String value) async {
                  await saveApiKey();
                  await GeminiService.init();
                },
              )),
          const SizedBox(
            width: 5,
          ),
          Text("${tr("howToGetOne")}?")
          //TODO make it hrefable
        ],
      ),
    );
    final Widget defaultLangInput = PrimaryContainer(
      paddingHorizontal: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tr("defaultLang")),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
              width: 100,
              child: TextField(
                controller: defaultLangController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    suffix: IconButton(
                        onPressed: () async {
                          await saveApiKey();
                        },
                        icon: const Icon(Icons.save))),
                onSubmitted: (String value) async {},
              )),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: SingleChildScrollView(
            child: Wrap(
          children: [
            aiApiKeyInput,
            defaultLangInput,
            generateSwitchList(
              onChanged: (value) async{
                await Shared.prefs.setBool("autoGenerateOnKey", value);
                setState((){});
              },
              title: Text("${tr("autoGenerate")} ${tr("onKey")}"),
              value: autoGenerateOnKey,
            ),
            generateSwitchList(
              onChanged: (value) async{
                await Shared.prefs.setBool("isDarkMode", value);
                setState((){});
              },
              title: Text(tr("darkMode")),
              value: isDarkMode,
            ),
            generateSwitchList(
              onChanged: (value)async {
                await Shared.prefs.setBool("autoGenerateOnLang", value);
                print(value);
                autoGenerateOnLang = autoGenerateOnLang;
                setState((){});
              },
              title: Text("${tr("autoGenerate")} ${tr("onLang")}"),
              value: autoGenerateOnLang,
            ),
            generateSwitchList(
              onChanged: (value) async{
                await Shared.prefs.setBool("autoGenerateOnCard", value);
                setState((){});
              },
              title: Text("${tr("autoGenerate")} ${tr("onCard")}"),
              value: autoGenerateOnCard,
            ),
            generateSwitchList(
              onChanged: (value)async {
                await Shared.prefs.setBool("generateMap", value);
                setState((){});
              },
              title: Text(tr("generateMap")),
              value: generateMap,
            ),
            generateSwitchList(
              onChanged: (value) async{
                await Shared.prefs.setBool("generateConstKeys", value);
                setState((){});
              },
              title: Text(tr("generateConstKeys")),
              value: generateConstKeys,
            ),
          ],
        )),
      ),
    );
  }

  generateSwitchList(
      {width = 300.0, required value, required title, required onChanged}) {
    return PrimaryContainer(
        width: width,
        child: SwitchListTile(
          hoverColor: Colors.transparent,
          activeColor: Colors.transparent,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(45)),
          title: title,
          value: value,
          onChanged: onChanged,
        ));
  }
}

//TODO change app name to treefy
// make the logo from the image of tree
