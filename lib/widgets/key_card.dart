import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/fn/general.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/general_widgets/click_detector.dart';
import 'package:localization_helper/screens/home/widgets/update_delete_dialog.dart';
import 'package:localization_helper/screens/key_page.dart';
import 'package:provider/provider.dart';

class KeyCard extends StatefulWidget {
  final String localizationKey;
  final double minWidth;

  const KeyCard({ super.key, required this.localizationKey, required this.minWidth });

  @override
  State<KeyCard> createState() => _KeyCardState();
}
late List<String> keyValues;

class _KeyCardState extends State<KeyCard> {
  late List<String> langs;
  late Localization localizationInstance;

  @override
  Widget build(BuildContext context) {
    localizationInstance =context.read<Localization>();
    keyValues = localizationInstance.getKeyValues(widget.localizationKey);
     return Column(
      mainAxisSize: MainAxisSize.min,
       children: [
         InkWell(
          onDoubleTap: () async{
            //update the data without provider in this way
            await  goTo(context,(context) => KeyPage(localizationKey: widget.localizationKey),);
              setState(() { });
          },
           child: ClickDetector(
            onRightClick: (){
              showUpdateDeleteKeyDialog(context, oldKey: widget.localizationKey);
            },
            
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              constraints: BoxConstraints(
                minWidth: widget.minWidth
              ),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: kAccentColor.withOpacity(0.2)))
              ),
              child: Row(mainAxisSize: MainAxisSize.min,
                children: [SizedBox(width: 100, child:AutoSizeText(
                  overflow: TextOverflow.ellipsis,
                  minFontSize: kMinFontSize,
                  widget.localizationKey)), ...List.generate(keyValues.length, (index) =>SizedBox(width: 100,
                child: AutoSizeText(keyValues[index],minFontSize: kMinFontSize,maxLines: 1,overflow: TextOverflow.ellipsis,),
              ) )],),
            ),
               ),
         ),
          
       ],
     );
  
  }
}