import 'package:flutter/material.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_helper/models/PrimaryContainer.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/screens/home/widgets/localization_dialog.dart';
import 'package:localization_helper/widgets/key_card.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});
  
  @override
  Widget build(BuildContext context) {
    var horizontalController = ScrollController();
    var verticalController = ScrollController();
    var mediaQuery = MediaQuery.sizeOf(context); //this to update the screen when size changes
    var keys = context.watch<Localization>().keys();
    var languages = context.watch<Localization>().languages();
    return Column(
      children: [
        AppBar(
          // refresh the home if the size of screen changed to show the menu or hide it
          title: Text(tr("home")),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
              IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showKeyDialog(context);
              },
            ),
          ],
        ),

        Scrollbar(
          thumbVisibility: true,
          controller: horizontalController ,
          child: SingleChildScrollView(
            controller: horizontalController ,
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
              PrimaryContainer(
              paddingHorizontal: 20,
              borderRadius: 0,
              margin: 0,
              child:  Row(children:[SizedBox(width: 100, child:  Text(tr("key"))),...List.generate(languages.length, (index) => SizedBox( width: 100, child:Text(languages[index],)),)]),
            ),
            SizedBox(
              height: mediaQuery.height -95,
                child: Scrollbar(
                  controller: verticalController,
                  thumbVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.left,
                  child: SingleChildScrollView(
                    
                    controller: verticalController,
                    child: Column(
                      children: List.generate(keys.length,(index) {
                      return KeyCard(localizationKey: keys[reverseIndex(listLength: keys.length, index: index)]);
                    }, )
                       
                    ),
                    
                  ),
                )),
            ],),
          ),
        ),
        
        
      ],
    );
  }
}

