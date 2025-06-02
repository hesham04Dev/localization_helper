import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:localization_helper/ai_services/ai_service.dart';
import 'dart:convert';
import 'dart:io';

import 'package:localization_helper/ai_services/gemini.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_helper/helpers/files_helper.dart';
import 'package:localization_lite/translate.dart';

class LocalizationData {
  Map<String, Map<String, String>> data = {};
  Map<String, Map<String, String>> filteredData = {};
  Map<String, List<String>> verifiedTranslation = {};
  Map<String, String> filters = {};

  _getData([isFiltered = true]) {
    if (isFiltered) {
      return filteredData;
    }
    return data;
  }

  LocalizationData() {
    String defaultLang = Shared.prefs.getString("defaultLang") ?? kDefaultLang;
    //TODO if default lang is not in an opened project then add it with the keys of the biggest length of the json that has been read
    data = {defaultLang: {}};
    restFilteredData();
  }

  List<String> languages({filtered = false}) {
    return _getData(filtered).keys.toList(growable: false);
  }

  List<String> keys({filtered = false}) {
    var _data = _getData(filtered);
    return _data.isEmpty
        ? []
        : _data[languages(filtered: true)[0]]?.keys.toList() ?? [];
  }

  List<String> getKeyValues(String key, {filtered = false}) {
    // print(filteredData);
    return languages(
      filtered: filtered,
    ).map((lang) => data[lang]?[key] ?? "").toList();
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

  void filterByLang(String lang) {
    filters["langFilter"] = lang;
    filters["keyFilter"] = "";
    if (filters["langFilter"] == "") {
      restFilteredData();
      return;
    }
    filteredData = {lang: data[lang] ?? {}};
  }

  void filterByKey(String key) {
    filters["keyFilter"] = key;
    var langs = languages();
    if (filters["langFilter"]?.isNotEmpty ?? false) {
      langs = [filters["langFilter"]!];
    }

    filteredData = {for (var lang in langs) lang: {}};
    final similarKeys =
        data[defaultLang()]?.keys
            .where((element) => element.contains(key))
            .toList(growable: false) ??
        [];

    for (var lang in langs) {
      final languageData = filteredData[lang]!;
      for (var key in similarKeys) {
        languageData[key] = data[lang]?[key] ?? "";
      }
    }
  }

  void restFilteredData() {
    filteredData = data;
  }

  void updateFilter() {
    restFilteredData();
    // print("the filters");
    // print(filters);
    if (filters["langFilter"]?.isNotEmpty ?? false) {
      filterByLang(filters["langFilter"] ?? "");
    }

    if (filters["keyFilter"]?.isNotEmpty ?? false) {
      filterByKey(filters["keyFilter"] ?? "");
    }
    //  print(filteredData);
  }

  void checkDefaultLang() {
    var usedDefaultLang = defaultLang();

    data.putIfAbsent(usedDefaultLang, () => {});

    String maxLengthLang = _getMaxLengthLang();

    if (maxLengthLang != usedDefaultLang) {
      var maxLengthEntries = data[maxLengthLang] ?? {};

      maxLengthEntries.forEach((key, value) {
        data[usedDefaultLang]?.putIfAbsent(key, () => "");
      });
    }
  }

  String _getMaxLengthLang() {
    if (data.isEmpty) {
      return defaultLang();
    }

    return data.entries
        .reduce(
          (maxEntry, currentEntry) =>
              currentEntry.value.length > maxEntry.value.length
                  ? currentEntry
                  : maxEntry,
        )
        .key;
  }

  void toggleVerifiedTranslation({
    required String langCode,
    required String key,
  }) {
    if (verifiedTranslation.containsKey(key)) {
      if (verifiedTranslation[key]!.contains(langCode)) {
        verifiedTranslation[key]?.remove(langCode);
      } else {
        verifiedTranslation[key]?.add(langCode);
      }
    } else {
      verifiedTranslation[key] = [langCode];
    }
  }

  bool isVerifiedTranslation({required String langCode, required String key}) {
    return verifiedTranslation[key]?.contains(langCode) ?? false;
  }
}

class LocalizationAIService {
  Future<Map<String, String>> fetchKeyValues(Map<String, String> param) async {
    try {
      var aiResponse = await AIService.model.getKeyValues(param);
      return Map<String, String>.from(jsonDecode(aiResponse));
    } catch (e) {
      print(e);
      // Error handling
      throw Exception("Failed to fetch AI translations");
    }
  }

  Future<Map<String, Map<String, String>>> fetchLangValues(
    String langCode,
    Map<String, Map<String, String>> param,
  ) async {
    try {
      var aiResponse = await AIService.model.getLangValues(param);
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
  final homeController = TextEditingController();
  final homeFocusNode = FocusNode();
  Map<String, String> homeControllerData = {};
  List<String> languages({bool filtered = true}) =>
      dataManager.languages(filtered: filtered);
  List<String> keys() => dataManager.keys();

  Future<void> addKey(String key) async {
    if (dataManager.keys().contains(key)) {
      errorToast(tr("keyExists"));
      return;
    }
    dataManager.addKey(key);
    dataManager.updateFilter();
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
    dataManager.updateFilter();
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  Future<bool> addLanguage(String langCode, {notify = true}) async {
    // return true if lang added exists
    if (dataManager.languages().contains(langCode)) {
      errorToast("${tr("langExists")} ");
      return false;
    }
    dataManager.addLang(langCode);
    dataManager.updateFilter();
    if (notify) notifyListeners();
    return true;
  }

  Future<void> saveToJson() async {
    await fileManager.saveToJson(dataManager.data);
    await fileManager.saveVerifiedTranslation(dataManager.verifiedTranslation);
  }

  Future<void> loadFromJson() async {
    dataManager.data = await fileManager.loadFromJson();
    dataManager.verifiedTranslation =
        await fileManager.loadVerifiedTranslation();
    dataManager.checkDefaultLang();
    dataManager.updateFilter();
    notifyListeners();
  }

  Future<void> saveToDart() async {
    await fileManager.saveToDart(dataManager.data);
  }

  Future<void> generateKeyValues(String key) async {
    if (dataManager.keys().contains(key)) {
      errorToast("${tr("keyExists")} ");
      return;
    }
    Map<String, String> param = {};
    param["key"] = key;
    param.addAll({
      for (var lang in languages()) lang: dataManager.data[lang]?[key] ?? "",
    });
    var result = await _aiService.fetchKeyValues(param);
    result.forEach((lang, value) {
      dataManager.data[lang]?[key] = value;
    });

    result.forEach((lang, value) {
      dataManager.data[lang]?[key] = value;
    });
    notifyListeners();
  }

  Future<void> generateCardValues(Map<String, String> param) async {
    String key = param["key"]!;
    Map<String, String> result = {};
    Map decoded;
    var aiResponse = await GeminiService().getKeyValues(param);
    try {
      decoded = jsonDecode(aiResponse);
    } catch (e) {
      errorToast(tr("aiFailedToResponse"));
      return;
    }
    decoded.forEach((key, value) {
      result[key] = value;
    });
    for (var lang in result.keys) {
      dataManager.data[lang]?[key] = result[lang] ?? "";
    }
    // print(dataManager.data);
    notifyListeners();
  }

  void updateLang({required oldCode, required newCode}) {
    if (dataManager.data.containsKey(newCode)) {
      // show alert
      return;
    }
    dataManager.data[newCode] = dataManager.data[oldCode]!;
    deleteLang(oldCode);
  }

  void deleteLang(code) {
    dataManager.data.remove(code);
    dataManager.updateFilter();
    notify();
  }

  // Future<void> generateLangValues(String langCode, [bool forComplete = false]) async {
  //   if(!forComplete){
  //   bool isAdded = await addLanguage(langCode, notify: false);
  //   if(!isAdded) return;}
  //   Map<String, Map<String, String>> param = {};

  //   param.addAll({defaultLang(): dataManager.data[defaultLang()]!});
  //   param.addAll({langCode: dataManager.data[langCode]!});

  //   Map<String, Map<String, String>> result = {};
  //   var aiResponse = await GeminiService().getLangValues(param);
  //   Map decoded;
  //   try {
  //     decoded = jsonDecode(aiResponse);
  //   } catch (e) {
  //      errorToast(tr("aiFailedToResponse"));
  //     return;
  //   }
  //   decoded.forEach((key, value) {
  //     result[key] = Map<String, String>.from(value);
  //   });

  //   dataManager.data[langCode] = result[langCode] ?? {};
  //   // print(dataManager.data);
  //   notifyListeners();
  // }

  Future<void> generateLangValues(
    String langCode, [
    bool forComplete = false,
  ]) async {
    if (!forComplete) {
      bool isAdded = await addLanguage(langCode, notify: false);
      if (!isAdded) return;
    }
    Map<String, Map<String, String>> param = {};
    if(dataManager.data[langCode]?.values.every((value) => value.trim() != "") ?? false){
      errorToast(tr("all_have_values"));
      return;
    }
    param.addAll({defaultLang(): dataManager.data[defaultLang()]!});
    param.addAll({langCode: dataManager.data[langCode]!});

    Map<String, String> result = {};
    var aiResponse = await GeminiService().getLangValues(param);
    Map decoded;
    try {
      decoded = jsonDecode(aiResponse);
    } catch (e) {
      errorToast(tr("aiFailedToResponse"));
      return;
    }
    decoded[langCode]?.forEach((key, value) {
      if ((dataManager.data[langCode]?.containsKey(key)?? false) && 
          dataManager.data[langCode]![key]!.isNotEmpty) {
         result[key] = dataManager.data[langCode]?[key] ?? "";
      }else{
        result[key] = value;
       
      }
    });

    dataManager.data[langCode] = result;
    // print(dataManager.data);
    notifyListeners();
  }
}
