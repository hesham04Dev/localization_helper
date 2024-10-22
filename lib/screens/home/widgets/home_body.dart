
import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controllers/localization.dart';
import 'package:localization_helper/widgets/key_card.dart';
import 'package:localization_lite/translate.dart';

class HomeBody extends StatelessWidget {
const HomeBody({ super.key });

  @override
  Widget build(BuildContext context){
    var keys = Localization.instance.keys();
    return Column(
      children: [
        AppBar(
           // refresh the home if the size of screen changed to show the menu or hide it
          title: Text(tr("home")),
          actions: [
            IconButton(icon: Icon(Icons.search),onPressed: (){},),
            IconButton(icon: Icon(Icons.add),onPressed: (){},),

          ],
        ),
        Expanded(child: Padding(
          padding: kSpacing,
          child: ListView.builder(itemBuilder: (context, index) {
            return KeyCard(localizationKey: keys[index] );
            
          },
          itemCount: keys.length,
          
          ),
        ))

      ],
    );
  }
}