// import 'package:flutter/material.dart';

// class Localization with ChangeNotifier {
  

//   //data shape like  {en:{key:value,},}
//   Map<String,Map<String,String>> data ={};
  
//   Localization(){
//     data = {"en": {"key": "value","key2":"val"},"ar":{"key":"value"}};//TODO use the same way as the extension
//   }
//   languages(){
//     return data.keys.toList(growable: false);
//   }
//   keys(){
//     return data[languages()[0]]?.keys.toList(growable: false);
//   }
//   getKeyValues(key){
//    List<String> values = [];
//     for(String lang in languages()){
//       values.add( data[lang]?[key]??"");
//     }
//     return values;
//   }
//   addKey(String key){
//     data.forEach((dataKey, value) {
//                 value.addAll({key:""});
//               },);
//     notifyListeners();
//   }
//   addLang(String langCode){
//       var keys = this.keys();
//                 Map<String,String> newLangData = {};
//               for(var key in keys ){
//                 newLangData.addAll({key:""});
//               }
//               data.addAll({langCode:newLangData});
//     notifyListeners();
//   }


//   //TODO to json 
//   //TODO from json


// }

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class Localization with ChangeNotifier {
  // Data shape like {en: {key: value,},}
  Map<String, Map<String, String>> data = {};
  String? path;
  Localization() {
    // Initialize with some default values
    data = {
      "en": {"key": "value", "key2": "val"},
      "ar": {"key": "value"}
    };
    data = {};
  }

  // Get available languages
  List<String> languages() {
    if(data.isEmpty) return [];
    return data.keys.toList(growable: false);
  }

  // Get keys for the default language
  List<String> keys() {
    if (data.isEmpty) return [];
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
  void addKey(String key) {
    data.forEach((dataKey, value) {
      value[key] = ""; // Add the key with an empty value
    });
    notifyListeners();
  }

  // Add a new language with keys initialized to empty values
  void addLang(String langCode) {
    var keysList = keys();
    Map<String, String> newLangData = {};
    if (keysList != null) {
      for (var key in keysList) {
        newLangData[key] = ""; // Initialize with empty values
      }
    }
    data[langCode] = newLangData; // Add new language to data
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