class Localization {
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

  //TODO to json
  //TODO from json


}