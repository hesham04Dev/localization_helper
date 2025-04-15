import 'package:flutter/material.dart';

import 'AutoDirection.dart';

class AutoDirectionTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool isUnderLinedBorder;
  final int? maxLines;
  final TextStyle? style;
  final InputDecoration? decoration;
  final FocusNode? focusNode;
  final Function(String value)? onChanged;
  final Function(String value)? onSubmitted;

  const AutoDirectionTextField(
      {super.key,
      required this.controller,
      this.hintText,
      this.isUnderLinedBorder = true,
      this.maxLines = 1,
      this.decoration,
      this.focusNode,
      this.onChanged,
      this.onSubmitted,
      this.style});

  @override
  State<AutoDirectionTextField> createState() =>
      _AutoDirectionTextFormFieldState();
}

class _AutoDirectionTextFormFieldState extends State<AutoDirectionTextField> {
  @override
  Widget build(BuildContext context) {
    return AutoDirection(
      text: widget.controller.text != ''
          ? widget.controller.text[0]
          : widget.controller.text,
      child: TextField(
        focusNode: widget.focusNode,
        onSubmitted: (value) {
          widget.onSubmitted?.call(value);
        },
        
        maxLines: widget.maxLines,
        controller: widget.controller,
        onChanged: (value) {
          widget.onChanged?.call(value);
          setState(() {});
        },
        decoration: widget.decoration,
        style: widget.style,
      ),
    );
  }
}