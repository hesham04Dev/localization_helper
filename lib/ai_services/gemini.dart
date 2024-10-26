import 'dart:convert';
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:localization_helper/aky.dart';

import 'ai_service.dart';

class GeminiService extends AIService {
  final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: geminiApi,
  );


  @override
  Future<String> getKeyValues(Map<String, String> keysAndValues) async {
    // Construct the prompt with flexible JSON structure for any languages
    // final prompt = '''
    // Important notes don't add more languages only fill the "".
    // I have the following key-value pairs with partial translations: $keysAndValues.
    // Please complete any missing translations in JSON format, keeping the existing structure and language codes.
    // The response should include all provided language codes, as well as any additional relevant translations Note return it as a string not a json.
    // Example:
    // {
    //   "key": "value",
    //   "langCode1": "langCode1 translation",
    //   ...
    // }
    // ''';
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
    final response = await model.generateContent(content);
    print(response.text);
    final result = removeMdJson(response.text??"");
  // Output the JSON response
    print(result);
    return result;
  }


  @override
Future<String> getLangValues(Map<String, Map<String, String>> langAndKeysAndValues) async {
  // Construct the prompt with a flexible structure to handle multiple languages
  // final prompt = '''
  // Very Important note if there is only key try to fill them and don't give me err if you don't know how to fill them keep them empty like this ""
  // Try to fill data as you can don't always give me ""
  // Very Important not give me the data for only the languages that i send to you not for another languages.
  // I give you a data only fill it.
  // don't add new keys.
  // don't add new langs.
  // I have the following translations by language: $langAndKeysAndValues.
  // For each language, please fill in any missing translations in JSON format, preserving the existing language codes and adding others as relevant Note return it as a string not a json.
  
  // Example:
  // {
  //   "langCode1": {"key1": "translation for langCode1", "key2": "translation for langCode1"},
  //   "langCode2": {"key1": "translation for langCode2", "key2": "translation for langCode2"},
  // }
  // ''';
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

print("aaa");
  print(langAndKeysAndValues);
  print("aaa");

  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);
  print(response.text);
  final result = removeMdJson(response.text??"");
  // Output the JSON response
  print(result);
  return result;
}

String removeMdJson(String content) {
  content = content.trim();
  const prefixLength = "```json".length;
  const suffixLength = "```".length;
  if (content.toLowerCase().startsWith("```json") && content.endsWith("```")) {
    content = content.substring(prefixLength, content.length - suffixLength).trim();
  }

  return content;
}
}
