import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

abstract class AIService {
  static late BuildContext context;
  // AIService({required this.context});

  Future<String> getLangValues(
      Map<String, Map<String, String>> langAndKeysAndValues) async {
    context.loaderOverlay.show();
    String values = await getCustomLangValues(langAndKeysAndValues);
    final result = removeMdJson(values);
    context.loaderOverlay.hide();
    return result;
  }

  Future<String> getCustomLangValues(
      Map<String, Map<String, String>> langAndKeysAndValues);

  Future<String> getKeyValues(Map<String, String> keysAndValues) async {
    context.loaderOverlay.show();
    String values = await getCustomKeyValues(keysAndValues);
    final result = removeMdJson(values);
    context.loaderOverlay.hide();
    return result;
  }

  Future<String> getCustomKeyValues(Map<String, String> keysAndValues);

  String removeMdJson(String content) {
    // get json content between ```json and ```
    var start = content.indexOf('```json') + 7;
    if (start > 0) {
      var end = content.indexOf('```', start);
      if (end >= 0) {
        return content.substring(start, end);
      }
    } else {
      // get json content between { and }
      var start = content.indexOf('{');
      if (start > 0) {
        var end = content.indexOf('}', start);
        if (end >= 0) {
          return content.substring(start, end -1);
        }
      } else {
        throw Exception("No JSON content found");
      }
    }
    return content;
  }
}
