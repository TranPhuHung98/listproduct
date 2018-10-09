import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_a/feature/add_item.dart';
import 'package:flutter_a/feature/delete_item.dart';
import 'package:flutter_a/feature/edit_number.dart';
import 'package:flutter_a/main.dart';
import 'package:flutter_a/model/admin.dart';
import 'package:flutter_a/model/item.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.user}) : super(key: key);
  FirebaseUser user;

  @override
  _HomeScreen createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool admin = false;
  DatabaseReference itemRef, adminRef;
  List<Item> items = List();
  Item item;
  List<Admin> admins = List();
  Admin adminAcc;

  void _signOut() {
    _googleSignIn.signOut();
    Navigator
        .of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => MyHomePage()));
  }

  _onAdminAdded(Event event) {
    setState(() {
      admins.add(Admin.fromSnapshot(event.snapshot));
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
    });
  }

  @override
  void initState() {
    super.initState();
    item = Item("", "", 0);
    adminAcc = Admin("");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    itemRef = database.reference().child('items');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
    adminRef = database.reference().child('admin');
    adminRef.onChildAdded.listen(_onAdminAdded);
  }

  @override
  Widget build(BuildContext context) {
    int leng = items.length;
    int lengAdmin = admins.length;
    for (int i = 0; i < lengAdmin; i++) {
      if (admins[i].admin == widget.user.email) {
        admin = true;
        break;
      }
    }

    Widget _drawer = Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.displayName),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: CircleAvatar(
              child: Image.network(widget.user.photoUrl),
              radius: 60.0,
            ),
          ),
          ListTile(
            title: Text("Đăng xuất"),
            onTap: _signOut,
            trailing: Icon(Icons.rotate_right),
          )
        ],
      ),
    );

    Widget _listProduct = Column(
      children: <Widget>[
        Expanded(
            child: ListView.builder(
          itemCount: leng,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(items[index].key),
              onDismissed: (direction) {
                if (admin)
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DeleteItem(
                            user: widget.user,
                            keyProduct: items[leng - index - 1].key,
                          )));
              },
              background: Container(
                color: Colors.grey,
                child: Center(
                  child: Text(
                    "Xóa",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.network(
                      items[leng - index - 1].image,
                      height: 150.0,
                      width: 180.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Tên: ${items[leng-index-1].name}",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                        Container(
                          padding: EdgeInsets.only(bottom: 40.0),
                          child:
                              Text("Số lượng: ${items[leng-index-1].number}"),
                        ),
                        FlatButton(
                          color: Colors.grey[300],
                          child: Text("Chỉnh sửa số lượng",
                              style: TextStyle(
                                color: Colors.blue,
                              )),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => EditProductCount(
                                      keyProduct: items[leng - index - 1].key,
                                      number: items[leng - index - 1].number,
                                      user: widget.user,
                                      name: items[leng - index - 1].name,
                                      historyProduct:
                                          items[leng - index - 1].image,
                                      image: items[leng - index - 1].image,
                                    )));
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ))
      ],
    );

    Widget _addProduct = FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => addItemScreen(
                user: widget.user,
              ))),
    );

    Future<bool> _onBackPressed() {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Bạn có muốn thoát ứng dụng này?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Không"),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  FlatButton(
                    child: Text("Có"),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ));
    }

    return MaterialApp(
        home: WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(),
        drawer: _drawer,
        floatingActionButton: admin == false ? null : _addProduct,
        body: _listProduct,
      ),
    ));
  }
}

// Future<Map> _neverSatisfied(String _postKey) async {
//       return showDialog<Map>(
//         context: context,
//         barrierDismissible: false, // user must tap button!
//         builder: (BuildContext context) {
//           return new AlertDialog(
//             title: new Text('Bạn có chắc chắc xóa sản phẩm này?'),
//             actions: <Widget>[
//               FlatButton(
//                 child: new Text('Xóa'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   FirebaseDatabase.instance
//                       .reference()
//                       .child("items/$_postKey")
//                       .remove();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
