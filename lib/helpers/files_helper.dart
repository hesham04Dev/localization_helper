// Helper class for managing file operations
import 'dart:convert';
import 'dart:io';

class LocalizationFileManager {
  Future<void> saveToJson(
      Map<String, Map<String, String>> data, String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) await dir.create(recursive: true);

    for (var lang in data.keys) {
      final filePath = '$dirPath/$lang.json';
      final jsonData = jsonEncode(data[lang]);
      await File(filePath).writeAsString(jsonData);
      print('Saved $filePath');
    }
  }

  Future<Map<String, Map<String, String>>> loadFromJson(String dirPath) async {
    final data = <String, Map<String, String>>{};
    final dir = Directory(dirPath);

    if (await dir.exists()) {
      for (var file in dir.listSync()) {
        if (file is File && file.path.endsWith('.json')) {
          final langCode = file.uri.pathSegments.last.split('.').first;
          final jsonString = await file.readAsString();
          data[langCode] = Map<String, String>.from(jsonDecode(jsonString));
        }
      }
    }
    return data;
  }
}