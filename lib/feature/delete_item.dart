import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_a/home_screen.dart';

class DeleteItem extends StatefulWidget {
  FirebaseUser user;
  String keyProduct;
  DeleteItem({Key key, this.user, this.keyProduct}) : super(key: key);

  @override
  _DeleteItemState createState() => _DeleteItemState();
}

class _DeleteItemState extends State<DeleteItem> {
  String _postKey = "";
  @override
  void initState() {
    super.initState();
    _postKey = widget.keyProduct;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            height: 150.0,
            width: 250.0,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Center(
                  child: Text("Bạn có chắc chắn xóa sản phẩm này?"),
                ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text("CÓ"),
                      color: Colors.grey,
                      textColor: Colors.black,
                      onPressed: (){
                        FirebaseDatabase.instance
                                  .reference()
                                  .child("items/$_postKey")
                                  .remove();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(user: widget.user,)));
                      },
                    ),
                    FlatButton(
                      child: Text("KHÔNG"),
                      color: Colors.grey,
                      textColor: Colors.black,
                      onPressed:() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(user: widget.user,))),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _onEntryChanged {
}