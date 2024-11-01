import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/controller/prefs.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:provider/provider.dart';

saveData(BuildContext context){
  context.read<Localization>().saveToJson();
}
openFolder(BuildContext context) async{
     context.read<Localization>().fileManager.path = await FilePicker.platform.getDirectoryPath();
   context.read<Localization>().loadFromJson();
}
Future goToWithReplacement(BuildContext context,WidgetBuilder builder) async{
  return await Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: builder),
  );
}
Future goTo(BuildContext context,WidgetBuilder builder) async{
  return await Navigator.push(
    context,
    MaterialPageRoute(builder: builder),
  );
}
int reverseIndex({required int listLength, required int  index}){
  return listLength - index -1;
}
defaultLang(){
  return Shared.prefs.getString("defaultLang")?? kDefaultLang;
}