import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localization_helper/aky.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';
import '../providers/localization.dart';
import 'ai_service.dart';

class ChatGPTService extends AIService {
  static const String name = "chatGpt";
  static const String model = "gpt-3.5-turbo";

  @override
  Future<String> getCustomKeyValues(Map<String, String> keysAndValues) async {
    final prompt = '''
    $kCommonKeyValuesPrompt
    ${jsonEncode(keysAndValues)}
    ''';

    final response = await _sendRequest(prompt);
    final result = removeMdJson(response ?? "");
    return result;
  }

  @override
  Future<String> getCustomLangValues(
    Map<String, Map<String, String>> langAndKeysAndValues,
  ) async {
    final prompt = '''
    $kCommonLangValuesPrompt
    ${jsonEncode(langAndKeysAndValues)}
    ''';

    final response = await _sendRequest(prompt);
    return response;
  }

  Future<String> _sendRequest(String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final apiKey = Shared.prefs.getString("apiKey") ?? "";
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": model,
        "messages": [
          {"role": "user", "content": prompt},
        ],
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      errorToast("${tr("failedToFetchFrom")} $name");
       
      return "{}";
      // throw Exception('Failed to fetch from $name');
      
    }
  }
}
