import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ai_service.dart';

class GeminiService extends AIService {
   static const String modelName = "Gemini";

  @override
  String get name => modelName;

  static const String model = "gemini-2.0-flash";

  final Uri url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=${AIService.apiKey}',
  );

  @override
  String? getResult() {
    return data['candidates']?[0]?['content']?['parts']?[0]?['text'];
  }

  @override
  Future<http.Response> getResponse(prompt) async{
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      }),
    );
  }
}
