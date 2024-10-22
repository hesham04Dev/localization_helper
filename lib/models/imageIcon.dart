import 'package:flutter/material.dart';

class IconImage extends StatelessWidget {
  final String iconName;
  final double size;
  final double opacity;
  Color? color;
  IconImage(
      {super.key,
      required this.iconName,
      this.size = 25,
      this.color,
      this.opacity = 1.0});
  @override
  Widget build(BuildContext context) {
    color ??= Theme.of(context).primaryColor.withOpacity(opacity);
    return Image.asset(
      "assets/icons/$iconName",
      height: size,
      width: size,
      color: color,
    );
  }
}
