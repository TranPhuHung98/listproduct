import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveLogin(int check, bool isLoadingSaved) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isSaved = (preferences.getBool('isSaved')??isLoadingSaved);
  if(check==1)  isSaved=isLoadingSaved;
  await preferences.setBool('isSaved', isSaved);
  return isSaved;
}