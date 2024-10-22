
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controllers/localization.dart';
import 'package:localization_helper/models/right_click_detector.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.05),
      padding: kSpacing ,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Row(
           
            children: [
            IconButton(icon: const Icon(Icons.settings),onPressed:(){} ,),
            const Expanded(child: SizedBox()),
            IconButton(icon: const Icon(Icons.folder),onPressed:(){} ,),
            IconButton(icon: const Icon(Icons.add),onPressed:(){} ,)
          ],),
         ...generateLangsTiles()
          
        ],
      ),
    );
  }
  List<Widget> generateLangsTiles(){
    List<Widget> langTiles =[];
    for(var langCode in Localization.instance.langues() ){

      langTiles.add( RightClickDetector(
        onRightClick: (){
          print("click right");//As long press 
        },
        child: ListTile(
              leading: const Icon(Icons.file_open),
              title: Text("$langCode.json"),
              onTap: () {
               //TODO show the keys and values for this lang only
              },
              onLongPress: () {
                //change lang code or delete dialog
                //or on right click
              },
            ),
      ),);
    }
    return langTiles;
  }

}
