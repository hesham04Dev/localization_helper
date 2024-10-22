import 'package:flutter/material.dart';

class HabitGiftTabPage extends StatelessWidget {
  final TabBarView tabBarView;
  final String title;
  const HabitGiftTabPage(
      {super.key, required this.tabBarView, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: const PreferredSize(
              preferredSize: Size(double.infinity, 5),
              child: TabBar(tabs: [Text("Habits"), Text("Gifts")])),
        ),
        body: tabBarView,
      ),
    );
  }
}
