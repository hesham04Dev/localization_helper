
import 'package:flutter/material.dart';
import 'package:localization_lite/translate.dart';

class Settings extends StatelessWidget {
const Settings({ super.key }) ;

  @override
  Widget build(BuildContext context){
    final Widget aiApiKeyInput = Column(children: [
      Text(tr("your_ai_api_key")),
      TextField(),
      Text(tr("how_to_get_one"))
      //TODO make it hrefable 
    ],); 

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          aiApiKeyInput
        ],
      ),
    );
  }
}

//TODO change app name to treefy
// make the logo from the image of tree
