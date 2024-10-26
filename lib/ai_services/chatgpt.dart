import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localization_helper/ai_services/ai_service.dart';

class ChatGPTService extends AIService {
  final String apiKey;

  ChatGPTService(this.apiKey);

  @override
  Future<String> fetchResponse(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": prompt}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to fetch from ChatGPT');
    }
  }
}
