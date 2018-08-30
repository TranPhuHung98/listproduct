import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_a/home_screen.dart';
import 'package:flutter_a/main.dart';
import 'package:flutter_a/other/app_bloc.dart';
import 'package:flutter_a/other/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final AppBloC appBloc;

  SplashScreen({Key key, this.appBloc}) : super(key: key);

  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool _isLogged = false;
  StreamSubscription<AppState> userSubcription;

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return Timer(_duration, navigationPage);
  }

//  Future navigationPage() async{
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    int count = (sharedPreferences.getInt('count')??0);
//
//    if(sharedPreferences.getInt('count')== 0){
//      Navigator.of(context).pushReplacementNamed('/welcome');
//      count ++ ;
//    }
//    else {
//      Navigator.of(context).pushReplacementNamed('/');
//    }
//    await sharedPreferences.setInt('count', count);
//
//
//  }
  void navigationPage() {
    _isLogged
        ? Navigator
            .of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => MyHomePage()))
        : Navigator
            .of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  void initState() {
    super.initState();
    startTime();

    setState(() {
      widget.appBloc.updateUser(AppState(widget.appBloc.getIsLoading()));
      userSubcription = widget.appBloc.appState.listen((s) {
        if (s.isLogged != _isLogged) {
          setState(() {
            _isLogged = s.isLogged;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    userSubcription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(""),
      ),
    );
  }
}
