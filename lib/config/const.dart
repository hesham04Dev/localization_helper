import 'package:flutter/material.dart';
import 'package:localization_helper/ai_services/gemini.dart';
//General const
const kLightGrey = Color(0xFFE8E8E8);
// const kDarkGrey = Color(0xFF202020);
const kDarkGrey = Color(0xFF0a140a);
const kWhite = Colors.white;
const kAccentColor = Colors.lightBlue;
const kFont = "Dubai";
const kSpacing = EdgeInsets.all(8);
const kDefaultLang = "en";
const kDefaultAiModel = GeminiService.name;

const double kMinFontSize= 10;

const String kCommonLangValuesPrompt = '''
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
''';

const String kCommonKeyValuesPrompt = '''
I have translations for specific languages structured as the example.
Please complete only the missing translations for each provided key and language without introducing any new keys or languages.

Instructions:
- Translate and fill missing values based on the keys and languages given.
- Do not add any new languages or keys.
- If unsure of a translation, leave the value as an empty string "".
- Return the completed JSON structure directly as a plain text string, not JSON-encoded.

Example:
Input:  
- {"key":"food", "en":""}
- {"key":"key1","en":"hello","ar":""}  

Output:  
- {"key":"food", "en":"Food"}
- {"key":"key1","en":"hello","ar":"مرحبا"}  

Here is the JSON data that requires completion:
''';

//const for this project
const double kDrawerWidth = 200;
const double kLargeScreenWidth = 800;
const double kLanguageWidth =100;


final primaryBorderRadius = BorderRadius.circular(45); /*not used*/
final secondaryBorderRadius = BorderRadius.circular(25); /*not used*/
