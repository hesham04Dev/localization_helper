import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localization_helper/aky.dart';
import 'ai_service.dart';

class ChatGPTService extends AIService {
// class GeminiService extends AIService {
  // final String apiKey;
  static const String model = "gpt-3.5-turbo";

  // ChatGPTService(this.apiKey);
  // GeminiService(this.apiKey);

  @override
  Future<String> getCustomKeyValues(Map<String, String> keysAndValues) async {
    final prompt = '''
Below is a JSON object containing key-value pairs with missing translations: $keysAndValues.

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

    final response = await _sendRequest(prompt);
    final result = removeMdJson(response ?? "");
    return result;
  }

  @override
  Future<String> getCustomLangValues(Map<String, Map<String, String>> langAndKeysAndValues) async {
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

    final response = await _sendRequest(prompt);
    return response;
  }

  Future<String> _sendRequest(String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $gptApi',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": model,
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

