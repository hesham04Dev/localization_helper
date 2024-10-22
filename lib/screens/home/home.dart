import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/screens/home/widgets/drawer_content.dart';
import 'package:localization_helper/screens/home/widgets/home_body.dart';
import 'package:localization_lite/translate.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isLargeScreen = constraints.maxWidth >= kLargeScreenWidth;

        return Scaffold(
          // appBar: AppBar(
          //   title: Text(tr("app_name")),
          // ),
          drawer: isLargeScreen ? null : const Drawer(
            child: DrawerContent(),
          ),
          body: Row(
            children: [
              // If it's a large screen, show the drawer as a side menu
              if (isLargeScreen)
                const SizedBox(
                  width: kDrawerWidth,
                  child:  DrawerContent(),
                ),
              const Expanded(
               child:  HomeBody(),
              ),
            ],
          ),
        );
      },
    );
  }
}

