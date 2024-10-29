import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:localization_helper/ai_services/gemini.dart';
import 'package:localization_helper/controller/prefs.dart';

class Localization with ChangeNotifier {
  Map<String, Map<String, String>> data = {};
  String? path;
  Localization() {
    String defaultLang = "en";
    //TODO if default lang is not in an opened project then add it with the keys of the biggest length of the json that has been read
    data = {defaultLang: {}};
  }

  List<String> languages() {
    if (data.isEmpty) return [];
    return data.keys.toList(growable: false);
  }

  List<String> keys() {
    if (data.isEmpty) return [];
    return data[languages()[0]]?.keys.toList(growable: false) ?? [];
  }

  // Get values for a specific key across all languages
  List<String> getKeyValues(String key) {
    List<String> values = [];
    for (String lang in languages()) {
      values.add(data[lang]?[key] ?? "");
    }
    return values;
  }

  // Add a new key to all languages
  void addKey(String key, {notify = true}) {
    data.forEach((dataKey, value) {
      value[key] = ""; // Add the key with an empty value
    });
    if (notify) notifyListeners();
  }

  void generateKeyValues(String key) async {
    addKey(key, notify: false);
    Map<String, String> param = {
      "key": key,
    };
    var langs = languages();
    for (var lang in langs) {
      param[lang] = data[lang]?[key] ?? "";
    }
    Map<String, String> result = {};
    var decoded = jsonDecode(await GeminiService().getKeyValues(param));
    decoded.forEach((key, value) {
      result[key] = value;
    });
    for (var lang in result.keys) {
      data[lang]?[key] = result[lang] ?? "";
    }
    print(data);
    notifyListeners();
  }

  void generateCardValues(Map<String, String> param) async {
    String key = param["key"]!;
    Map<String, String> result = {};
    var decoded = jsonDecode(await GeminiService().getKeyValues(param));
    decoded.forEach((key, value) {
      result[key] = value;
    });
    for (var lang in result.keys) {
      data[lang]?[key] = result[lang] ?? "";
    }
    print(data);
    notifyListeners();
  }

  // Add a new language with keys initialized to empty values
  void addLang(String langCode, {notify = true}) {
    var keysList = keys();
    Map<String, String> newLangData = {};
    for (var key in keysList) {
      newLangData[key] = ""; // Initialize with empty values
    }
    data[langCode] = newLangData; // Add new language to data
    if (notify) {
      notifyListeners();
    }
  }

  void generateLangValues(String langCode) async {
    addLang(langCode, notify: false);
    Map<String, Map<String, String>> param = {};
    param.addAll({"en": data["en"]!});
    param.addAll({langCode: data[langCode]!});

    Map<String, Map<String, String>> result = {};
    var decoded = jsonDecode(await GeminiService().getLangValues(param));
    decoded.forEach((key, value) {
      result[key] = Map<String, String>.from(value);
    });

    data[langCode] = result[langCode] ?? {};
    print(data);
    notifyListeners();
  }

  // Convert localization data to separate JSON files for each language
  // Future<void> toJson() async {
  //   var dirPath = await _getPath();
  //   final dir = Directory(dirPath);

  //   // Create the directory if it doesn't exist
  //   if (!await dir.exists()) {
  //     await dir.create(recursive: true);
  //   }

  //   for (var lang in data.keys) {
  //     final filePath = '$dirPath/$lang.json';
  //     final jsonData = jsonEncode(data[lang]);
  //     await File(filePath).writeAsString(jsonData);
  //     print('Saved $filePath');
  //   }
  // }

Future<void> toDartFile() async {
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
    for (var key in keys()) {
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

  Future<void> toJson() async {
    var dirPath = await _getPath();
    final dir = Directory(dirPath);

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    for (var lang in data.keys) {
      final filePath = '$dirPath/$lang.json';
      final jsonData = jsonEncode(data[lang]);
      await File(filePath).writeAsString(jsonData);
      print('Saved $filePath');
    }

    // Generate Dart file if generateMap is enabled
    await toDartFile();
  }

  // Load localization data from JSON files in a specified directory
  Future<void> fromJson() async {
    final dir = Directory(await _getPath());

    if (await dir.exists()) {
      List<FileSystemEntity> files = dir.listSync();

      for (var file in files) {
        if (file is File && file.path.endsWith('.json')) {
          final langCode = file.uri.pathSegments.last.split('.').first;
          final jsonString = await file.readAsString();
          data[langCode] = Map<String, String>.from(jsonDecode(jsonString));
        }
      }
      notifyListeners();
    } else {
      print("Directory does not exist");
    }
  }

  _getPath() async {
    path ??= await FilePicker.platform.getDirectoryPath();
    return path;
  }
}
