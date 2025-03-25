import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

abstract class AIService {
  static late BuildContext context;
  // AIService({required this.context});

  Future<String> getLangValues(
      Map<String, Map<String, String>> langAndKeysAndValues) async {
    context.loaderOverlay.show();
    String values = await getCustomLangValues(langAndKeysAndValues);
    context.loaderOverlay.hide();
    return values;
  }

  Future<String> getCustomLangValues(
      Map<String, Map<String, String>> langAndKeysAndValues);

  Future<String> getKeyValues(Map<String, String> keysAndValues) async {
    context.loaderOverlay.show();
    String values = await getCustomKeyValues(keysAndValues);
    context.loaderOverlay.hide();
    return values;
  }

  Future<String> getCustomKeyValues(Map<String, String> keysAndValues);
}
