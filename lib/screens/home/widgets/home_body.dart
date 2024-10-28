import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:localization_helper/config/const.dart';
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
    var scroll = ScrollController();
    
    MediaQuery.sizeOf(context).width; //this to update the screen when size changes
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
        
        PrimaryContainer(
          paddingHorizontal: 20,
          borderRadius: 0,
          margin: 0,
          child:  Row(children:[SizedBox(width: 100, child:  Text(tr("key"))),...List.generate(languages.length, (index) => SizedBox( width: 100, child:Text(languages[index],)),)]),
        ),
        Expanded(
            child: Padding(
          padding: kSpacing,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 5,
            ),
            itemBuilder: (context, index) {
              return KeyCard(localizationKey: keys[index]);
            },
            itemCount: keys.length,
          ),
        )),
        
      ],
    );
  }
}
