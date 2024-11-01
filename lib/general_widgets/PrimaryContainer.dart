import 'package:flutter/material.dart';

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double opacity;
  final double padding;
  final bool withBorder;
  final double? paddingHorizontal;
  final double margin;
  final double borderRadius;
  final BoxConstraints? constraints;
  const PrimaryContainer({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.opacity = 0.1,
    this.padding = 8,
    this.paddingHorizontal,
    this.margin = 8,
    this.withBorder = false,
    this.borderRadius = 45,
    this.constraints
  });

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    return Container(
      clipBehavior: Clip.hardEdge,
      height: height,
      width: width,
      constraints: constraints,
      padding: EdgeInsets.symmetric(
          vertical: padding, horizontal: paddingHorizontal ?? padding),
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color.withOpacity(opacity),
          border: withBorder ? Border.all(color: color, width: 2) : null),
      child: child,
    );
  }
}
