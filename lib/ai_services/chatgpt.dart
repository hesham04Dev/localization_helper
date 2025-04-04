import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_service.dart';

class ChatGPTService extends AIService {
  static const String modelName = "chatGpt";
  static const String model = "gpt-3.5-turbo";
  @override
  String get name => modelName;

  final Uri url = Uri.parse('https://api.openai.com/v1/chat/completions');

  @override
  String? getResult() {
    return data['choices'][0]['message']['content'];
  }

  @override
  Future<http.Response> getResponse(prompt) async{
    return await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${AIService.apiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": model,
        "messages": [
          {"role": "user", "content": prompt},
        ],
      }),
    );
  }
}
