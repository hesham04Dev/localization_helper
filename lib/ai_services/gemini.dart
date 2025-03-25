import 'dart:convert';
import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:localization_helper/aky.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_lite/translate.dart';

import 'ai_service.dart';

class GeminiService extends AIService {
  static var model;

  // GeminiService({required super.context});
  
  static init(BuildContext context) {
    AIService.context = context;
    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: Shared.prefs.getString("apiKey") ?? "",
    );
  }

  @override
  Future<String> getCustomKeyValues(Map<String, String> keysAndValues) async {
    
    final prompt = '''
I have the following key-value pairs, with some keys potentially missing values: $keysAndValues.
Please attempt to generate values for these keys in each provided language code. Complete any missing translations in JSON format and include the language codes listed, even if values are empty ("") when necessary.

Important Instructions:
- Only use the provided keys and language codes; do not add any new keys or languages.
- Attempt to generate values for keys without values where possible. If uncertain, leave the value as an empty string "".
- Return the response as a string, not JSON-encoded.

Example:
i send to you {"key":"food", "en":"",} or with any other lang
then you send to me {"key":"food", "en":"Food"} or maybe i send to you something like this 
{"key":"key1","en":"hello","ar":""}
then you send to me {"key":"key1","en":"hello","ar":"مرحبا"}

''';
    final content = [Content.text(prompt)];
    late final response;
    late final result;
    try {
      response = await model.generateContent(content);
      // print(response.text);
      result = removeMdJson(response.text ?? "");
    } catch (e) {
      return e.toString();
    }
    // print(result);
    return result ?? "";
  }

  @override
  Future<String> getCustomLangValues(
      Map<String, Map<String, String>> langAndKeysAndValues) async {
    final prompt = '''
I have translations for specific languages structured as the example.
Please complete only the missing translations for each provided key and language without introducing any new keys or languages.

Instructions:
- Translate and fill missing values based on the keys and languages given.
- Do not add any new languages or keys.
- If unsure of a translation, leave the value as an empty string "".
- Return the completed JSON structure directly as a plain text string, not JSON-encoded.

Example:
Input:
{"en":{"hello":"","key2":"Street"},"ar":{"hello":"","key2":""}}
Output:
{"en":{"hello":"Hello","key2":"Street"},"ar":{"hello":"مرحبا","key2":"شارع"}}

Here is the JSON data that requires completion:
${jsonEncode(langAndKeysAndValues)}
''';
    final content = [Content.text(prompt)];
    late final response;
    late final result;
    try {
      response = await model.generateContent(content);
      // print(response.text);
      result = removeMdJson(response.text ?? "");
      // print(result);
    } catch (e) {
      return e.toString();
    }

    return result;
  }

  String removeMdJson(String content) {
    content = content.trim();
    const prefixLength = "```json".length;
    const suffixLength = "```".length;
    if (content.toLowerCase().startsWith("```json") &&
        content.endsWith("```")) {
      content =
          content.substring(prefixLength, content.length - suffixLength).trim();
    }

    return content;
  }
}
