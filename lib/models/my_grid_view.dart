import 'package:flutter/material.dart';

class MyGridView extends StatelessWidget {
  final int itemCount;
  final Function itemBuilder;
  const MyGridView(
      {super.key, required this.itemBuilder, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemBuilder: (context, index) => itemBuilder(context, index),
        itemCount: itemCount,
        shrinkWrap: false,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            childAspectRatio: 135 / 160,
            maxCrossAxisExtent: 135,
            mainAxisExtent: 160));
  }
}
