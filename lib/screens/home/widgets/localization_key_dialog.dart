import 'package:flutter/material.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_lite/translate.dart';

class LocalizationKeyDialog extends StatelessWidget {
const LocalizationKeyDialog({ super.key });

  @override
  Widget build(BuildContext context){
    String key ="";
    var localizationKeyInput = SizedBox (width: 250, child:  TextField(onChanged: (value) => key = value,decoration: const InputDecoration(hintText: "Key"),));
   
    return Dialog(

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            localizationKeyInput,
            SizedBox(height: 5,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [TextButton(onPressed: (){
              
            //   Localization.instance.data.forEach((dataKey, value) {
            //     value.addAll({key:""});
            //   },);
            // //TODO provider 
            // //TODO auto add from ai in the langs
            // // or add the default langs
        
            print(Localization.instance.data);
            Navigator.pop(context);
            }, child: Text(tr("save")))
            ,FilledButton(onPressed: (){}, child: Text(tr("generate")))],)
            
          ],
        ),
      ),
    );
  }
}
//TODO check if key exists 
// and not empty