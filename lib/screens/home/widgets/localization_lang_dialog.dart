import 'package:flutter/material.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_lite/translate.dart';

class LocalizationLangDialog extends StatelessWidget {
const LocalizationLangDialog({ super.key });

  @override
  Widget build(BuildContext context){
    String LangCode ="";
    var localizationKeyInput = SizedBox (width: 250, child:  TextField(onChanged: (value) => LangCode = value,decoration: const InputDecoration(hintText: "Lang code"),));
   
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
              //   var keys =Localization.instance.keys();
              //   Map<String,String> newLangData = {};
              // for(var key in keys ){
              //   newLangData.addAll({key:""});
              // }
              

              // Localization.instance.data.addAll({LangCode:newLangData});
            //TODO provider 
            //TODO auto add from ai in the langs
            // or add the default langs

            
        
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
//TODO check if lang exists or if it is is
// and not empty