import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'dart:convert';
import 'dart:io';

import 'package:localization_helper/ai_services/gemini.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/helpers/files_helper.dart';
import 'package:localization_lite/translate.dart';

class LocalizationData {
  Map<String, Map<String, String>> data = {};

  LocalizationData() {
    String defaultLang = Shared.prefs.getString("defaultLang") ?? kDefaultLang;
    //TODO if default lang is not in an opened project then add it with the keys of the biggest length of the json that has been read
    data = {defaultLang: {}};
  }

  List<String> languages() => data.keys.toList(growable: false);

  List<String> keys() =>
      data.isEmpty ? [] : data[languages()[0]]?.keys.toList() ?? [];

  List<String> getKeyValues(String key) {
    return languages().map((lang) => data[lang]?[key] ?? "").toList();
  }

  void addKey(String key) {
    data.forEach((lang, value) => value[key] = "");
  }

  void addLang(String langCode) {
    Map<String, String> newLangData = {for (var key in keys()) key: ""};
    data[langCode] = newLangData;
  }

  void deleteKey(String key) {
    data.forEach((_, langData) => langData.remove(key));
  }

  void deleteLang(String langCode) {
    data.remove(langCode);
  }
}

class LocalizationAIService {
  Future<Map<String, String>> fetchKeyValues(
      String key, Map<String, String> param) async {
    try {
      var aiResponse = await GeminiService().getKeyValues(param);
      return Map<String, String>.from(jsonDecode(aiResponse));
    } catch (e) {
      // Error handling
      throw Exception("Failed to fetch AI translations");
    }
  }

  Future<Map<String, Map<String, String>>> fetchLangValues(
      String langCode, Map<String, Map<String, String>> param) async {
    try {
      var aiResponse = await GeminiService().getLangValues(param);
      return Map<String, Map<String, String>>.from(jsonDecode(aiResponse));
    } catch (e) {
      // Error handling
      throw Exception("Failed to fetch language values");
    }
  }
}

class Localization with ChangeNotifier {
  final LocalizationData dataManager = LocalizationData();
  final LocalizationFileManager fileManager = LocalizationFileManager();
  final LocalizationAIService _aiService = LocalizationAIService();
  CherryToast? toast;

  List<String> languages() => dataManager.languages();
  List<String> keys() => dataManager.keys();

  Future<void> addKey(String key) async {
    dataManager.addKey(key);
    notifyListeners();
  }

  void updateKey({required oldKey, required newKey}) {
    var langs = languages();

    for (var lang in langs) {
      if (dataManager.data[lang]?.containsKey(newKey) ?? false) {
        // show alert
        return;
      }
    }

    for (var lang in langs) {
      dataManager.data[lang]?[newKey] = dataManager.data[lang]?[oldKey] ?? "";
    }

    deleteKey(oldKey);
  }

  void deleteKey(code) {
    var langs = languages();
    for (var lang in langs) {
      dataManager.data[lang]?.remove(code);
    }
    notifyListeners();
  }

  void notify(){
    notifyListeners();
  }
 

  Future<void> addLanguage(String langCode,{notify =true}) async {
    dataManager.addLang(langCode);
   if(notify) notifyListeners();
  }

  Future<void> saveToJson() async {
    await fileManager.saveToJson(dataManager.data);
  }

  Future<void> loadFromJson() async {
    dataManager.data = await fileManager.loadFromJson();
    notifyListeners();
  }
  Future<void> saveToDart() async {
    await fileManager.saveToDart(dataManager.data);
  }
  Future<void> generateKeyValues(String key) async {
    var param = {
      for (var lang in languages()) lang: dataManager.data[lang]?[key] ?? ""
    };
    var result = await _aiService.fetchKeyValues(key, param);
    result.forEach((lang, value) {
      dataManager.data[lang]?[key] = value;
    });
    notifyListeners();
  }

 void generateCardValues(Map<String, String> param) async {
    String key = param["key"]!;
    Map<String, String> result = {};
    Map decoded;
    var aiResponse = await GeminiService().getKeyValues(param);
    try{decoded = jsonDecode(aiResponse);}catch(e){
      toast = errorToast(tr("aiFailedToResponse"));
      return;
    }
    decoded.forEach((key, value) {
      result[key] = value;
    });
    for (var lang in result.keys) {
      dataManager.data[lang]?[key] = result[lang] ?? "";
    }
    print(dataManager.data);
    notifyListeners();
  }


  void updateLang({required oldCode,required newCode}){
    if(dataManager.data.containsKey(newCode)){
      // show alert
      return;
    }
    dataManager.data[newCode] = dataManager.data[oldCode]!;
    deleteLang(oldCode);

  }
  void deleteLang(code){
    dataManager.data.remove(code);
    notify();
  }
  void generateLangValues(String langCode) async {
    addLanguage(langCode, notify: false);
    Map<String, Map<String, String>> param = {};
    param.addAll({"en": dataManager.data["en"]!});
    param.addAll({langCode: dataManager.data[langCode]!});

    Map<String, Map<String, String>> result = {};
    var aiResponse = await GeminiService().getLangValues(param);
    Map decoded;
    try{decoded = jsonDecode(aiResponse);}catch(e){
      toast = errorToast(tr("aiFailedToResponse"));
        return;
    }
    decoded.forEach((key, value) {
      result[key] = Map<String, String>.from(value);
    });

    dataManager.data[langCode] = result[langCode] ?? {};
    print(dataManager.data);
    notifyListeners();
  }


  void showToast(BuildContext context) {
    toast?.show(context);
    toast = null;
  }

  CherryToast errorToast(String message) {
    return CherryToast.error(title: Text(message));
  }
}

//TODO need to be edit remove the gemini and use the abstract class to use other ai services
// improve the prompt for the key

