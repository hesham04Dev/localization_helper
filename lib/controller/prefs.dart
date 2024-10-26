import 'package:shared_preferences/shared_preferences.dart';

class  Shared {
  
  static late final  SharedPreferences prefs;
  static Future<void>  init() async{
   prefs  = await SharedPreferences.getInstance();
  }
  Shared._();
}