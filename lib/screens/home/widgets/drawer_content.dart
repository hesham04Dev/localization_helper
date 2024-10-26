
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_helper/main.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/models/click_detector.dart';
import 'package:localization_helper/screens/home/widgets/localization_dialog.dart';
import 'package:localization_helper/screens/settings/settings.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';

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
            IconButton(icon: const Icon(Icons.settings),onPressed:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings(),));
            } ,),
            const Expanded(child: SizedBox()),
            IconButton(icon: const Icon(Icons.folder),onPressed:(){
              openFolder(context);
            } ,),
            IconButton(icon: const Icon(Icons.save),onPressed:(){
              saveData(context);
            } ,),
            IconButton(icon: const Icon(Icons.add),onPressed:(){showLangDialog(context);} ,),
            // ShortcutButton(icon: const Icon(Icons.add), logicalKeySet: LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift, LogicalKeyboardKey.keyN), onClick: (){
            //   showDialog(context: context, builder: (context) =>  LocalizationDialog( hintText: tr("langCode"),
            //     saveClick: (String input) { context.read<Localization>().addLang(input);  }, generateClick: (String input) {  },),);
            // })
          ],),

         ...generateLangsTiles(context)
          
        ],
      ),
    );
  }
  List<Widget> generateLangsTiles(BuildContext context){
    List<Widget> langTiles =[];
    for(var langCode in context.watch<Localization>().languages() ){

      langTiles.add( ClickDetector(
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
    return langTiles??[];
  }

}
