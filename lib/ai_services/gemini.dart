import 'dart:convert';
import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:localization_helper/aky.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_lite/translate.dart';

import 'ai_service.dart';

class GeminiService extends AIService {
  static const String name = "Gemini";
  static var model;

  // GeminiService({required super.context});

  // static init_() {
  //   model = GenerativeModel(
  //     model: 'gemini-2.0-flash',
  //     apiKey: Shared.prefs.getString("apiKey") ?? "",
  //   );
  // }
  GeminiService(){
    model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: Shared.prefs.getString("apiKey") ?? "",
    );
  }

  @override
  Future<String> getCustomKeyValues(Map<String, String> keysAndValues) async {
    final prompt = '''
    $kCommonKeyValuesPrompt
    ${jsonEncode(keysAndValues)}
    ''';

    final content = [Content.text(prompt)];
    print("content: ");
    print(prompt);
    late final response;
    late final result;
    try {
      response = await model.generateContent(content);
      print("response: ");
      print(response.text);
    } catch (e) {
       errorToast("${tr("failedToFetchFrom")} $name");
       
      return "{}";
    }
    // print(result);
    return response.text ?? "";
  }

  @override
  Future<String> getCustomLangValues(
      Map<String, Map<String, String>> langAndKeysAndValues) async {
    final prompt = '''
    $kCommonLangValuesPrompt
    ${jsonEncode(langAndKeysAndValues)}
    ''';

    final content = [Content.text(prompt)];
    late final response;
    late final result;
    try {
      response = await model.generateContent(content);
      // print(response.text);
      // result = removeMdJson(response.text ?? "");
      // print(result);
    } catch (e) {
      errorToast("${tr("failedToFetchFrom")} $name");
      return "{}";
    }

    return response.text ?? "";
  }
}
