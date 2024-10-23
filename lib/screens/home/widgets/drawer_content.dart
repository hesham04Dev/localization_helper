
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/models/click_detector.dart';
import 'package:localization_helper/screens/home/widgets/localization_lang_dialog.dart';

import '../../../models/PrimaryContainer.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      borderRadius: 0,
      margin: 0,
      padding: 8 ,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Row(
           
            children: [
            IconButton(icon: const Icon(Icons.settings),onPressed:(){} ,),
            const Expanded(child: SizedBox()),
            IconButton(icon: const Icon(Icons.folder),onPressed:(){} ,),
            IconButton(icon: const Icon(Icons.add),onPressed:(){
              showDialog(context: context, builder: (context) => const LocalizationLangDialog(),);
            } ,)
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
