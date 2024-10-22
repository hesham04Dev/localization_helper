import 'package:flutter/material.dart';

TextStyle titleStyle(BuildContext context) {
  var primaryColor = Theme.of(context).primaryColor;
  return TextStyle(color: primaryColor, fontWeight: FontWeight.bold);
}

final ShapeBorder tileShape = OutlineInputBorder(
    borderRadius: BorderRadius.circular(35), borderSide: BorderSide.none);
