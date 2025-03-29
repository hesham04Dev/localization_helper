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
      model: 'gemini-2.0-flash',
      apiKey: Shared.prefs.getString("apiKey") ?? "",
    );
  }

  @override
  Future<String> getCustomKeyValues(Map<String, String> keysAndValues) async {

    final prompt = '''
  Below is a JSON object containing key-value pairs with missing translations: ${jsonEncode(keysAndValues)}.
  
  **Your task:**  
  - Fill in missing values where possible.  
  - Do NOT change existing values.  
  - If unsure, leave the value as an empty string ("").  
  - Do NOT add new keys or new languages.  
  - Do NOT include explanations, messages, or formatting—return ONLY the JSON.  

  **Example Input:**  
  {"key":"food", "en":""}  
  {"key":"key1","en":"hello","ar":""}  

  **Example Output:**  
  {"key":"food", "en":"Food"}  
  {"key":"key1","en":"hello","ar":"مرحبا"}  

  **DO NOT add extra text. Only return a valid JSON string.**
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
      return e.toString();
    }
    // print(result);
    return response.text ?? "";
  }

  @override
  Future<String> getCustomLangValues(
      Map<String, Map<String, String>> langAndKeysAndValues) async {
//     final prompt = '''
// I have translations for specific languages structured as the example.
// Please complete only the missing translations for each provided key and language without introducing any new keys or languages.

// Instructions:
// - Translate and fill missing values based on the keys and languages given.
// - Do not add any new languages or keys.
// - If unsure of a translation, leave the value as an empty string "".
// - Return the completed JSON structure directly as a plain text string, not JSON-encoded.
// - Do NOT include explanations, messages, or formatting—return ONLY the JSON.
// - Give only for the missing values 
// - Dont add any new keys or languages

// Example:
// Input:
// {"en":{"hello":"","key2":"Street"},"ar":{"hello":"","key2":""}}
// Output:
// {"en":{"hello":"Hello","key2":"Street"},"ar":{"hello":"مرحبا","key2":"شارع"}}

// Here is the JSON data that requires completion:
// ${jsonEncode(langAndKeysAndValues)}
// ''';
    

    final prompt = '''
You are given a JSON object containing translations for multiple languages. Some values are missing and need to be completed.

### Instructions:
- **Fill in missing values** using accurate and contextually appropriate translations.
- **Do NOT modify existing translations.**
- **Do NOT add new keys or languages**—only work with what is provided.
- **If a translation is unclear or cannot be determined, leave the value as an empty string ("").**
- **Return ONLY the JSON output, without explanations or extra formatting.**

### Example:
#### Input:
{"en": {"hello": "", "key2": "Street"}, "ar": {"hello": "", "key2": ""}}
#### Expected Output:
{"en": {"hello": "Hello", "key2": "Street"}, "ar": {"hello": "مرحبا", "key2": "شارع"}}
Now, complete the missing translations for the following data:
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
      return e.toString();
    }

    return response.text ?? "";
  }

  
}
