import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_lite/translate.dart';

import '../config/const.dart';
import '../controller/prefs.dart';
import 'deep_seek.dart';
import 'gemini.dart';
import 'chatgpt.dart';

abstract class AIService {
  static late BuildContext context;
  static const  aiModels = [
    GeminiService.modelName,
    ChatGPTService.modelName,
    DeepSeekService.modelName,
  ];
  static late AIService model;
  String get name;
  late Map data;
  static late final String apiKey;

  static init(context) async{
    apiKey = Shared.prefs.getString("apiKey")??"";
    AIService.context = context;
    setModel();
  }
  static setModel(){
    final modelName = Shared.prefs.getString("defaultAiModel")??kDefaultAiModel;
    print("modelName: $modelName");
      switch(modelName){
      case GeminiService.modelName : model = GeminiService();
      break;
      case ChatGPTService.modelName : model =  ChatGPTService();
      break;
      case DeepSeekService.modelName : model = DeepSeekService();
      break;
    }
  }

 String? getResult();
 Future<http.Response> getResponse(String prompt);


  Future<String> getLangValues(
    Map<String, Map<String, String>> langAndKeysAndValues) async {
    context.loaderOverlay.show();
    String values = await getCustomLangValues(langAndKeysAndValues);
    final result = removeMdJson(values);
    context.loaderOverlay.hide();
    return result;
  }

  Future<String> getKeyValues(Map<String, String> keysAndValues) async {
    context.loaderOverlay.show();
    String values = await getCustomKeyValues(keysAndValues);
    final result = removeMdJson(values);
    context.loaderOverlay.hide();
    return result;
  }


  Future<String> getCustomKeyValues(Map<String, String> keysAndValues) async {
    final prompt = '''
    $kCommonKeyValuesPrompt
    ${jsonEncode(keysAndValues)}
    ''';

    final result = await _sendRequest(prompt)??"{}";
    return result;
  }

  Future<String> getCustomLangValues(
      Map<String, Map<String, String>> langAndKeysAndValues) async {
    final prompt = '''
    $kCommonLangValuesPrompt
    ${jsonEncode(langAndKeysAndValues)}
    ''';

    return await _sendRequest(prompt) ?? "{}";
  }

  Future<String?> _sendRequest(String prompt) async {
    final apiKey = Shared.prefs.getString("apiKey") ?? "";

    final response = await getResponse(prompt);

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return getResult()??"{}";
    } else {
      errorToast("${tr("failedToFetchFrom")} ${model.name}");
      return "{}";
    }
  }



 String removeMdJson(String content) {
  // Try to extract content between ```json and ```
  final jsonCodeBlockPattern = RegExp(r'```json\s*([\s\S]*?)\s*```');
  final codeBlockPattern = RegExp(r'```\s*([\s\S]*?)\s*```');
  final jsonPattern = RegExp(r'\{[\s\S]*?\}');

  final matchJsonBlock = jsonCodeBlockPattern.firstMatch(content);
  if (matchJsonBlock != null) {
    return matchJsonBlock.group(1)!.trim();
  }

  // Fallback: extract content between ``` and ```
  final matchCodeBlock = codeBlockPattern.firstMatch(content);
  if (matchCodeBlock != null) {
    return matchCodeBlock.group(1)!.trim();
  }

  // Fallback: extract first JSON-like object
  final matchJson = jsonPattern.firstMatch(content);
  if (matchJson != null) {
    return matchJson.group(0)!.trim();
  }

  throw Exception("No JSON content found");
}

}
