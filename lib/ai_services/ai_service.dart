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
  static const aiModels = [
    GeminiService.modelName,
    ChatGPTService.modelName,
    DeepSeekService.modelName,
  ];
  static late AIService model;
  String get name;
  late Map data;
  static late final String apiKey;

  static init(context) async {
    apiKey = Shared.prefs.getString("apiKey") ?? "";
    AIService.context = context;
    setModel();
  }

  static setModel() {
    final modelName =
        Shared.prefs.getString("defaultAiModel") ?? kDefaultAiModel;
    print("modelName: $modelName");
    switch (modelName) {
      case GeminiService.modelName:
        model = GeminiService();
        break;
      case ChatGPTService.modelName:
        model = ChatGPTService();
        break;
      case DeepSeekService.modelName:
        model = DeepSeekService();
        break;
    }
  }

  String? getResult();
  Future<http.Response> getResponse(String prompt);

  Future<String> getLangValues(
    Map<String, Map<String, String>> langAndKeysAndValues,
  ) async {
    context.loaderOverlay.show();
    final prompt = '''
    $kCommonLangValuesPrompt
    ${jsonEncode(langAndKeysAndValues)}
    ''';
    print("prompt: $prompt");
    final values = await _sendRequest(prompt);
    final result = removeMdJson(values);
    print("result: $values");
    context.loaderOverlay.hide();
    return result;
  }

  Future<String> getKeyValues(Map<String, String> keysAndValues) async {
    context.loaderOverlay.show();

    final prompt = '''
    $kCommonKeyValuesPrompt
    ${jsonEncode(keysAndValues)}
    ''';

    final values = await _sendRequest(prompt);
    final result = removeMdJson(values);
    context.loaderOverlay.hide();
    return result;
  }

  Future<String> _sendRequest(String prompt) async {
    final apiKey = Shared.prefs.getString("apiKey") ?? "";

    final response = await getResponse(prompt);

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return getResult() ?? "{}";
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

    int startIndex = content.indexOf('{');
    int endIndex = content.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
      final jsonStr = content.substring(startIndex, endIndex + 1);
      return jsonStr;
    }
    errorToast(tr("failedToParseResponse"));
    throw Exception("No JSON content found");
  }
}
