import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/screens/home/widgets/drawer_content.dart';
import 'package:localization_helper/screens/home/widgets/home_body.dart';
import 'package:localization_helper/screens/home/widgets/shortcuts.dart';


class Home extends StatelessWidget {
const Home({ super.key });

  @override
  Widget build(BuildContext context){
      return LayoutBuilder(
      builder: (context, constraints) {
        bool isLargeScreen = constraints.maxWidth >= kLargeScreenWidth;

    return ShortcutsLayer(
      child: Scaffold(
                  drawer: isLargeScreen ? null : const Drawer(
                    child: DrawerContent(),
                  ),
                  body: Row(
                    children: [
                      if (isLargeScreen)
                        const SizedBox(
                          width: kDrawerWidth,
                          child: DrawerContent(),
                        ),
                      const Expanded(
                        child: HomeBody(),
                      ),
                    ],
                  ),
                ),
    );});
  }
}

