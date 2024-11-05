import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_helper/general_widgets/PrimaryContainer.dart';
import 'package:localization_helper/general_widgets/imageIcon.dart';
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
    var mediaQuery = MediaQuery.sizeOf(context); //this to update the screen when size changes
    var keys = context.watch<Localization>().dataManager.keys(filtered: true);
    print(keys.length);
    print("my keys");
    var languages = context.watch<Localization>().dataManager.languages(filtered: true);


print(keys);
print(languages);
    double getMinWidth(){

    var totalWidth = mediaQuery.width;
    var availableWidth = totalWidth;
    if(totalWidth > kLargeScreenWidth){
       availableWidth -= kDrawerWidth;
    }
    if(availableWidth > 0)    return availableWidth;
    return 0;
  }
    var minCardWidth = getMinWidth();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          // refresh the home if the size of screen changed to show the menu or hide it
          title: Text(tr("home")),
          actions: [
            IconButton(
              icon: IconImage(iconName: "search.png",),
              onPressed: () {
                showSearchDialog(context);
              },
            ),
              IconButton(
              icon: IconImage(iconName: "star.png",size: 20,),
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
              mainAxisSize: MainAxisSize.min,
              children: [
              PrimaryContainer(
              paddingHorizontal: 20,
              borderRadius: 0,
              constraints: BoxConstraints(
                minWidth: minCardWidth
              ),
              margin: 0,
              child:  Row(children:[SizedBox(width: kLanguageWidth, child:  Text(tr("key"))),...List.generate(languages.length, (index) => SizedBox( width: kLanguageWidth, child:Text(languages[index],)),),]),
            ),
            SizedBox(
              height: mediaQuery.height -95,
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(keys.length,(index) {
                    return KeyCard(minWidth: minCardWidth,localizationKey: keys[reverseIndex(listLength: keys.length, index: index)]);
                  }, )
                     
                  ),
                  
                )),
            ],),
          ),
        ),
        
        
      ],
    );
  }

  

}

