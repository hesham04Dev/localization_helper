import 'package:flutter/material.dart';

class Localization with ChangeNotifier {
  

  //data shape like  {en:{key:value,},}
  Map<String,Map<String,String>> data ={};
  
  Localization(){
    data = {"en": {"key": "value","key2":"val"},"ar":{"key":"value"}};//TODO use the same way as the extension
  }
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
    data.forEach((dataKey, value) {
                value.addAll({key:""});
              },);
    notifyListeners();
  }
  addLang(String langCode){
      var keys = this.keys();
                Map<String,String> newLangData = {};
              for(var key in keys ){
                newLangData.addAll({key:""});
              }
              data.addAll({langCode:newLangData});
    notifyListeners();
  }

  //TODO to json
  //TODO from json


}