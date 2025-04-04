import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localization_helper/aky.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_lite/translate.dart';
import 'ai_service.dart';

class DeepSeekService extends AIService {
  static const String modelName = "deepSeek";
  @override
  String get name => modelName;

  static const String model = "deepseek-chat";



  final Uri url = Uri.parse('https://api.deepseek.com/v1/chat/');

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
