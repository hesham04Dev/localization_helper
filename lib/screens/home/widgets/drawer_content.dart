
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_helper/general_widgets/imageIcon.dart';
import 'package:localization_helper/main.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/general_widgets/click_detector.dart';
import 'package:localization_helper/screens/home/widgets/localization_dialog.dart';
import 'package:localization_helper/screens/home/widgets/update_delete_dialog.dart';
import 'package:localization_helper/screens/settings/settings.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';

import '../../../general_widgets/PrimaryContainer.dart';

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
            IconButton(icon: IconImage(iconName: "settings.png"),onPressed:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings(),));
            } ,),
            const Expanded(child: SizedBox()),
            IconButton(icon:  IconImage(iconName: "folder.png"),onPressed:(){
              openFolder(context);
            } ,),
            IconButton(icon: IconImage(iconName: "save.png"),onPressed:(){
              saveData(context);
            } ,),
            IconButton(icon: IconImage(iconName: "star.png",size: 20,),onPressed:(){showLangDialog(context);} ,),
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
          showUpdateDeleteLangDialog(context, oldCode: langCode);
        },
        child: ListTile(
              leading: IconImage(iconName: "file.png"),
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
