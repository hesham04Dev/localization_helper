import 'package:flutter/material.dart';

import '../config/styles.dart';

class MySwitchTile extends StatefulWidget {
  MySwitchTile(
      {super.key, required this.title, this.value = false, this.onChange});

  @override
  State<MySwitchTile> createState() => _MySwitchTileState();
  bool value;
  Function? onChange;
  final String title;
}

class _MySwitchTileState extends State<MySwitchTile> {
  @override
  Widget build(BuildContext context) {
    widget.onChange ??= (value) {};
    return SwitchListTile(
        title: Text(widget.title),
        shape: tileShape,
        value: widget.value,
        onChanged: (value) {
          widget.onChange!(value);
          widget.value = value;
          setState(() {});
        });
  }
}
