import 'package:asset_icon/asset_icon.dart';
import 'package:flutter/material.dart';
import 'package:localization_helper/ai_services/ai_service.dart';
import 'package:localization_helper/ai_services/gemini.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/general_widgets/PrimaryContainer.dart';
import 'package:localization_helper/providers/theme_provider.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var themeInstance = context.read<ThemeProvider>();
    var apiKeyController = TextEditingController();
    var defaultLangController = TextEditingController();
    bool autoGenerateOnKey = Shared.prefs.getBool("autoGenerateOnKey") ?? false;
    bool autoGenerateOnLang =
        Shared.prefs.getBool("autoGenerateOnLang") ?? false;
    bool autoGenerateOnCard =
        Shared.prefs.getBool("autoGenerateOnCard") ?? false;
    bool generateMap = Shared.prefs.getBool("generateMap") ?? false;
    bool generateConstKeys = Shared.prefs.getBool("generateConstKeys") ?? false;
    bool isDarkMode = themeInstance.darkMode;
    saveApiKey() async {
      await Shared.prefs.setString("apiKey", apiKeyController.text);
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
                decoration: InputDecoration(),
                obscureText: true,
                onSubmitted: (String value) async {
                  await saveApiKey();
                  await AIService.setModel();
                },
              )),
          IconButton(
              onPressed: () async {
                await saveApiKey();
                await AIService.setModel();
              },
              icon: AssetIcon("save.svg")),
          const SizedBox(
            width: 5,
          ),
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
              width: 50,
              child: TextField(
                controller: defaultLangController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(),
                onSubmitted: (String value) async {
                  print("new lang is:$value");
                  await Shared.prefs.setString("defaultLang", value);
                  setState(() {});
                },
              )),
          IconButton(
              onPressed: () async {
                
                  await Shared.prefs.setString("defaultLang", defaultLangController.text);
                  setState(() {});
              },
              icon: AssetIcon("save.svg"))
        ],
      ),
    );

    final Widget defaultAiModel = PrimaryContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tr("defaultAiModel")),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
              width: 150,
              child: DropdownButton(
                value: Shared.prefs.getString("defaultAiModel") ??
                    kDefaultAiModel,
                items: AIService.aiModels.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) async {
                  await Shared.prefs.setString("defaultAiModel", value!);
                  await AIService.setModel();
                  setState(() {});
                },
              )),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () async {
                  var url = Uri.parse("https://aistudio.google.com/app/apikey");
                  if (!await launchUrl(url)) {
                    throw 'Could not launch $url';
                  }
                },
                child: Text("${tr("getFreeGeminiApi")}?")),
            const SizedBox(
              width: double.infinity,
              height: 20,
            ),
            Wrap(
              children: [
                aiApiKeyInput,
                defaultAiModel,
                defaultLangInput,
                generateSwitchList(
                  onChanged: (value) async {
                    await Shared.prefs.setBool("autoGenerateOnKey", value);
                    setState(() {});
                  },
                  title: Text("${tr("autoGenerate")} ${tr("onKey")}"),
                  value: autoGenerateOnKey,
                ),
                generateSwitchList(
                  onChanged: (value) async {
                    themeInstance.toggleMode();
                    setState(() {});
                  },
                  title: Text(tr("darkMode")),
                  value: isDarkMode,
                ),
                generateSwitchList(
                  onChanged: (value) async {
                    await Shared.prefs.setBool("autoGenerateOnLang", value);
                    // print(value);
                    autoGenerateOnLang = autoGenerateOnLang;
                    setState(() {});
                  },
                  title: Text("${tr("autoGenerate")} ${tr("onLang")}"),
                  value: autoGenerateOnLang,
                ),
                generateSwitchList(
                  onChanged: (value) async {
                    await Shared.prefs.setBool("autoGenerateOnCard", value);
                    setState(() {});
                  },
                  title: Text("${tr("autoGenerate")} ${tr("onCard")}"),
                  value: autoGenerateOnCard,
                ),
                // generateSwitchList(
                //   onChanged: (value) async {
                //     await Shared.prefs.setBool("generateMap", value);
                //     setState(() {});
                //   },
                //   title: Text(tr("generateMap")),
                //   value: generateMap,
                // ),
                // generateSwitchList(
                //   onChanged: (value) async {
                //     await Shared.prefs.setBool("generateConstKeys", value);
                //     setState(() {});
                //   },
                //   title: Text(tr("generateConstKeys")),
                //   value: generateConstKeys,
                // ),
              ],
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
