import 'package:flutter/material.dart';

class FlatContainer extends StatelessWidget {
  final Widget child;
  const FlatContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            color: isDarkMode ? Colors.black : Colors.white),
        child: child);
  }
}
