import 'package:flutter/material.dart';

class Localization with ChangeNotifier {
  static late Localization instance ;

  //data shape like  {en:{key:value,},}
  Map<String,Map<String,String>> data ={};
  static void init(){
    instance = Localization._();
    instance.data = {"en": {"key": "value","key2":"val"},"ar":{"key":"value"}};//TODO use the same way as the extension
  }
  
  Localization._();
  langues(){
    return data.keys.toList(growable: false);
  }
  keys(){
    return data[langues()[0]]?.keys.toList(growable: false);
  }
  getKeyValues(key){
   List<String> values = [];
    for(String lang in langues()){
      values.add( data[lang]?[key]??"");
    }
    return values;
  }
  addKey(String key){
    instance.data.forEach((dataKey, value) {
                value.addAll({key:""});
              },);
    notifyListeners();
  }
  addLang(String langCode){
      var keys =instance.keys();
                Map<String,String> newLangData = {};
              for(var key in keys ){
                newLangData.addAll({key:""});
              }
              Localization.instance.data.addAll({langCode:newLangData});
    notifyListeners();
  }

  //TODO to json
  //TODO from json


}