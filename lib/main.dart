import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_a/home_screen.dart';
import 'package:flutter_a/other/app_bloc.dart';
import 'package:flutter_a/other/app_state.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

Future<Null> _configure() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: "",
    options: FirebaseOptions(
        googleAppID: "1:619530952670:android:df36a995ceb4ab49",
        apiKey: "AIzaSyBNqqSlvxNQ-i46kHbSTBOXZtxF7eA8rsM",
        databaseURL: "https://fashtion2.firebaseio.com"),
  );
  assert(app != null);
  print('Configured $app');
}

void main() {
  AppBloC appBloC = AppBloC();
  runApp(new MaterialApp(home:MyHomePage(
    appBloc: appBloC,
  )));
  // runApp(HomeScreen());
}

// class MyApp extends StatelessWidget {
//   final AppBloC appBloc;
//   bool _isLogged = false;
//   StreamSubscription<AppState> userSubcription;
//   MyApp({Key key, this.appBloc}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // home: SplashScreen(appBloc: appBloc,),
//       home: MyHomePage(
//         appBloc: appBloc,
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget  {
  final AppBloC appBloc;
  MyHomePage({Key key, this.title, this.appBloc}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool loading = true;
  AnimationController _animationController;

  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)));
    return user;
  }

  void _signOut() {
    _googleSignIn.signOut();
    print("outtttttttttttt");
    bool isLoading = false;
    int check = 1;
    widget.appBloc.saveLogged(isLoading, check);
    widget.appBloc.updateUser(AppState(isLoading));
  }

  @override
    void initState() {
      super.initState();
      _animationController = AnimationController(duration: Duration(seconds: 10),vsync: this)..repeat();
  }

  @override
    void dispose() {
      super.dispose();
      _animationController.dispose();
    }



  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
        body: new Center(
      child: loading == false
          ? CircularProgressIndicator()
          : Container(
              child: FlatButton(
                padding: EdgeInsets.only(
                  left: 0.0,
                  right: 0.0,
                ),
                onPressed: () {
                  setState(() {
                    loading = false;
                  });
                  _handleSignIn()
                      .then((FirebaseUser user) => print(user))
                      .catchError((e) {
                    print("aaaaaaaaaaaaaa$e");
                    if (e != null) setState(() => loading = true);
                  });
                },
                child: Image.asset(
                  "images/google.png",
                  height: 100.0,
                  width: 250.0,
                ),
              ),
            ),
    ));
  }
}
