import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../config/const.dart';
import '../controller/prefs.dart';
import 'deep_seek.dart';
import 'gemini.dart';
import 'chatgpt.dart';

abstract class AIService {
  static late BuildContext context;
  // AIService({required this.context});
  static const  aiModels = [
    GeminiService.name,
    ChatGPTService.name,
    DeepSeekService.name,
  ];
   static late AIService model;
  static init(context) async{
    AIService.context = context;
    setModel();
  }
  static setModel(){
    final modelName = Shared.prefs.getString("defaultAiModel")??kDefaultAiModel;
    print("modelName: $modelName");
      switch(modelName){
      case GeminiService.name : model = GeminiService();
      break;
      case ChatGPTService.name : model =  ChatGPTService();
      break;
      case DeepSeekService.name : model = DeepSeekService();
      break;
    }
  }

  Future<String> getLangValues(
    Map<String, Map<String, String>> langAndKeysAndValues) async {
    context.loaderOverlay.show();
    String values = await getCustomLangValues(langAndKeysAndValues);
    final result = removeMdJson(values);
    context.loaderOverlay.hide();
    return result;
  }

  Future<String> getCustomLangValues(
      Map<String, Map<String, String>> langAndKeysAndValues);

  Future<String> getKeyValues(Map<String, String> keysAndValues) async {
    context.loaderOverlay.show();
    String values = await getCustomKeyValues(keysAndValues);
    final result = removeMdJson(values);
    context.loaderOverlay.hide();
    return result;
  }

  Future<String> getCustomKeyValues(Map<String, String> keysAndValues);

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
