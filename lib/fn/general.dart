import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:provider/provider.dart';

saveData(BuildContext context){
  context.read<Localization>().toJson();
}
openFolder(BuildContext context) async{
     context.read<Localization>().path = await FilePicker.platform.getDirectoryPath();
   context.read<Localization>().fromJson();
}