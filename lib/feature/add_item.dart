import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_a/home_screen.dart';
import 'package:flutter_a/model/item.dart';
import 'package:image_picker/image_picker.dart';

class addItemScreen extends StatefulWidget {
  String keyProduct;
  int number;
  FirebaseUser user;
  String name;

  addItemScreen({Key key, this.keyProduct, this.number, this.name, this.user})
      : super(key: key);
  @override
  _addItemScreen createState() {
    return _addItemScreen();
  }
}

class _addItemScreen extends State<addItemScreen> {
  Item item;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameCon, numberCon;
  String nameString, numberString, _path;
  File _image;
  bool isAdding = false;

  Future getImageCam() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getImageLib() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<Null> uploadPicture(
      String filepath, String nameString, String numberString) async {
    final ByteData byte = await rootBundle.load(filepath);
    final Directory tempDir = Directory.systemTemp;
    final String filename = '${Random().nextInt(1000000)}.jpg';
    final File file = File('${tempDir.path}/$filename');
    file.writeAsBytes(byte.buffer.asInt8List(), mode: FileMode.write);

    StorageReference ref = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask task = ref.putFile(file);
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();
    print(_path);
    FirebaseDatabase.instance.reference().child("items").push().set({
      "image": _path,
      "name": nameString,
      "number": int.parse(numberString)
    });
    setState(() {
      isAdding = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.blue;
    return Scaffold(
      body: Container(
          child: Center(
        child: Container(
            padding: EdgeInsets.only(right:10.0,left: 10.0),
            height: 500.0,
            width: 350.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _image == null
                    ? SizedBox(
                        height: 200.0,
                      )
                    : SizedBox(
                        height: 100.0,
                      ),
                _image == null
                    ? new Text('Chưa có ảnh')
                    : new Image.file(
                        _image,
                        height: 100.0,
                      ),
                TextField(
                  onChanged: (String str) {
                    setState(() {
                      nameString = str;
                    });
                  },
                  decoration: InputDecoration(labelText: "Tên"),
                ),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  onChanged: (String str) {
                    setState(() {
                      numberString = str;
                    });
                  },
                  decoration: InputDecoration(labelText: "Số lượng"),
                ),
                SizedBox(
                  height: 5.0,
                ),
                RaisedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    if (_image != null) {
                      uploadPicture(_image.path, nameString, numberString);
                    } else
                      FirebaseDatabase.instance
                          .reference()
                          .child("items")
                          .push()
                          .set({
                        "image": "",
                        "name": nameString,
                        "number": int.parse(numberString)
                      });

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => HomeScreen(
                              user: widget.user,
                            )));
                  },
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "Chụp ảnh",
                        style: TextStyle(color: color),
                      ),
                      onPressed: getImageCam,
                    ),
                    FlatButton(
                      child: Text("Chọn ảnh từ thư viện",
                          style: TextStyle(color: color)),
                      onPressed: getImageLib,
                    )
                  ],
                )
              ],
            )),
      )),
    );
  }
}
