// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:localization_helper/ai_services/ai_service.dart';

// class ClaudeService extends AIService {
//   final String apiKey;

//   ClaudeService(this.apiKey);

//   @override
//   Future<String> fetchResponse(String prompt) async {
//     final response = await http.post(
//       Uri.parse('https://api.anthropic.com/v1/complete'),
//       headers: {
//         'x-api-key': apiKey,
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         "model": "claude-1",
//         "prompt": prompt,
//         "max_tokens_to_sample": 100,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['completion'];
//     } else {
//       throw Exception('Failed to fetch from Claude');
//     }
//   }
// }
