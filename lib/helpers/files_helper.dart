import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/fn/general.dart';

class LocalizationFileManager {
  String? path;
    _getPath() async {
    path ??= await FilePicker.platform.getDirectoryPath();
    return path;
  }
  Future<void> saveToJson(
      Map<String, Map<String, String>> data) async {
    final dir = Directory(await _getPath());
    if (!await dir.exists()) await dir.create(recursive: true);

    for (var lang in data.keys) {
      final filePath = '${dir.path}/$lang.json';
      final jsonData = jsonEncode(data[lang]);
      await File(filePath).writeAsString(jsonData);
      print('Saved $filePath');
    }
  }

  Future<Map<String, Map<String, String>>> loadFromJson() async {
    final data = <String, Map<String, String>>{};
    final dir = Directory(await _getPath());

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

Future<void> saveToDart(Map<String, Map<String, String>> data) async {
  // Check preferences for map and constant keys generation
  final shouldGenerateMap = Shared.prefs.getBool("generateMap") ?? false;
  final shouldGenerateConstantKeys = Shared.prefs.getBool("generateConstKeys") ?? false;

  // Exit early if neither option is enabled
  if (!shouldGenerateMap && !shouldGenerateConstantKeys) return;

  final dirPath = await _getPath();
  final filePath = '$dirPath/localization_map.dart';
  final file = File(filePath);
  final buffer = StringBuffer();

  // Add constant keys class if enabled
  if (shouldGenerateConstantKeys) {
    buffer.writeln("class LocalizationKeys {");
    for (String key in data[defaultLang()]?.keys??[]) {
      buffer.writeln("  static const String ${_toCamelCase(key)} = '$key';");
    }
    buffer.writeln("}\n");
  }

  // Exit if map generation is disabled
  if (!shouldGenerateMap) {
    await file.writeAsString(buffer.toString());
    print("Generated Dart localization file with keys at $filePath");
    return;
  }

  // Add language translation maps and localization class for map generation
  buffer
    ..writeln("// Auto-generated localization file.")
    ..writeln("import 'package:flutter/material.dart';\n");

  data.forEach((lang, translations) {
    buffer.writeln("const Map<String, String> ${lang}Translations = {");
    translations.forEach((key, value) {
      buffer.writeln("  '$key': '''$value''',");
    });
    buffer.writeln("};\n");
  });

  buffer
    ..writeln("class Localizations {")
    ..writeln("  static Map<String, Map<String, String>> data = {");

  data.keys.forEach((lang) {
    buffer.writeln("    '$lang': ${lang}Translations,");
  });
  
  buffer
    ..writeln("  };")
    ..writeln("}\n");

  // Write the buffer to the Dart file
  await file.writeAsString(buffer.toString());
  print("Generated Dart localization file at $filePath");
}

// Helper function to convert a key to camelCase for constant names
String _toCamelCase(String key) {
  return key
      .split('_')
      .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
      .join()
      .replaceFirstMapped(RegExp(r'^[A-Z]'), (match) => match[0]!.toLowerCase());
}
}