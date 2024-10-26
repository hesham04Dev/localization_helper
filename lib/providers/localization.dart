import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:localization_helper/ai_services/gemini.dart';

class Localization with ChangeNotifier {
  Map<String, Map<String, String>> data = {};
  String? path;
  Localization() {
    String defaultLang = "en";
    //todo if default lang is not in an opened project then add it with the keys of the biggest length of the json that has been read
    data = {defaultLang:{}};
  }


  List<String> languages() {
    if(data.isEmpty) return [];
    return data.keys.toList(growable: false);
  }

  List<String> keys() {
    if (data.isEmpty) return [];
    //
    return data[languages()[0]]?.keys.toList(growable: false) ??[];
  }

  // Get values for a specific key across all languages
  List<String> getKeyValues(String key) {
    List<String> values = [];
    for (String lang in languages()) {
      values.add(data[lang]?[key] ?? "");
    }
    return values;
  }

  // Add a new key to all languages
  void addKey(String key,{notify=true}) {
    data.forEach((dataKey, value) {
      value[key] = ""; // Add the key with an empty value
    });
    if(notify)notifyListeners();
  }
  void generateKeyValues(String key)async {
    addKey(key,notify:false);
    Map<String,String> param = {"key":key,};
    var langs = languages();
    for(var lang in langs){
      param[lang] = data[lang]?[key]??"";
    }
    Map<String,String> result = {};
    var decoded = jsonDecode(await GeminiService().getKeyValues(param));
     decoded.forEach((key, value) {
    result[key] = value;
  });
      for(var lang in  result.keys){
        data[lang]?[key] = result[lang]??"";
      }
    print(data);
    notifyListeners();
  }

  void generateCardValues(Map<String, String> param) async{
    String key = param["key"]!;
        Map<String,String> result = {};
    var decoded = jsonDecode(await GeminiService().getKeyValues(param));
     decoded.forEach((key, value) {
    result[key] = value;
  });
      for(var lang in  result.keys){
        data[lang]?[key] = result[lang]??"";
      }
    print(data);
    notifyListeners();
  }
  // Add a new language with keys initialized to empty values
  void addLang(String langCode,{notify=true}) {
    var keysList = keys();
    Map<String, String> newLangData = {};
    if (keysList != null) {
      for (var key in keysList) {
        newLangData[key] = ""; // Initialize with empty values
      }
    }
    data[langCode] = newLangData; // Add new language to data
    if(notify){  notifyListeners();}
  }
  void generateLangValues(String langCode)async {
    addLang(langCode,notify:false);
    Map<String,Map<String,String>> param = {};
    param.addAll({"en":data["en"]!});
    param.addAll({langCode:data[langCode]!});

    Map<String,Map<String,String>> result = {};
    // result.addAll(jsonDecode(await GeminiService().getLangValues(param)));
    var decoded = jsonDecode(await GeminiService().getLangValues(param));
    decoded.forEach((key, value) {
    result[key] = Map<String, String>.from(value);
  });

    data[langCode] = result[langCode]??{};
    print(data);
  //    Map<String, Map<String, String>> result = {};

  // // Corrected JSON string with double quotes
  //  final decoded = jsonDecode('{"en": {"home": "Home"}, "ar": {"home": "Home"}}') as Map<String, dynamic>;

  // // Convert each value to the expected type and add to result
  // decoded.forEach((key, value) {
  //   result[key] = Map<String, String>.from(value);
  // });
  // Map<String, Map<String, String>> data = {};
  
  // data[langCode] = result[langCode] ?? {};
  // print(data);


    notifyListeners();
  }

  // Convert localization data to separate JSON files for each language
  Future<void> toJson() async {
    //TODO make the directory path a memeber in the class
    var dirPath = await _getPath();
    final dir = Directory(dirPath);

    // Create the directory if it doesn't exist
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    for (var lang in data.keys) {
      final filePath = '$dirPath/$lang.json';
      final jsonData = jsonEncode(data[lang]);
      await File(filePath).writeAsString(jsonData);
      print('Saved $filePath');
    }
  }

  // Load localization data from JSON files in a specified directory
  Future<void> fromJson() async {
    final dir = Directory(await _getPath());

    if (await dir.exists()) {
      List<FileSystemEntity> files = dir.listSync();

      for (var file in files) {
        if (file is File && file.path.endsWith('.json')) {
          final langCode = file.uri.pathSegments.last.split('.').first;
          final jsonString = await file.readAsString();
          data[langCode] = Map<String, String>.from(jsonDecode(jsonString));
        }
      }
      notifyListeners(); // Notify listeners after loading new data
    } else {
      print("Directory does not exist");
    }
  }
  
  _getPath() async{

    path??= await FilePicker.platform.getDirectoryPath();
    return path;
  }
}
//TODO if the location is empty then open folder dialog to get a folder if not auto save 