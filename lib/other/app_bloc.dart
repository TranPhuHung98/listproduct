import 'dart:async';

import 'package:flutter_a/other/app_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloC{
  int check=0;
  final _app_state = BehaviorSubject<AppState>();

  updateUser(AppState state) {
    _app_state.add(state);
  }

  Stream<AppState> get appState => _app_state.stream;

  bool isLoading = false;
  Future<bool> saveLogged(bool isLoading,int check) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLoadingSave = (sharedPreferences.getBool('isLoadingSave')??isLoading );
    if( check == 1)
      isLoadingSave = isLoading ;
    await sharedPreferences.setBool('isLoadingSave', isLoadingSave);
    return isLoadingSave ;
  }


  void dangXuat(){
    isLoading = false ;
    check = 1 ;
    saveLogged(isLoading,check) ;
    updateUser(AppState(isLoading));
  }

  bool getIsLoading(){
    saveLogged(isLoading,check).then((value){
      isLoading = value ;
    });
    saveLogged(isLoading,check);
    return isLoading ;
  }
}