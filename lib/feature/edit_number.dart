import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_a/model/history_edit.dart';
import 'package:flutter_a/model/item.dart';

class EditProductCount extends StatefulWidget {
  String keyProduct;
  int number;
  FirebaseUser user;
  String name;
  String historyProduct;
  String image;
  EditProductCount(
      {Key key,
      this.keyProduct,
      this.number,
      this.name,
      this.user,
      this.historyProduct,
      this.image})
      : super(key: key);
  @override
  _EditProductCountState createState() => _EditProductCountState();
}

class _EditProductCountState extends State<EditProductCount> {
  int _postCount = 0;
  String _postKey = "";
  String _productName;
  int _oldPostCount = 0;
  String _historyProduct = "";
  String _postImage = "";
  List<Item> listHistory;
  List<ItemHis> itemsHis = List();
  ItemHis itemHis;
  DatabaseReference itemRefHis;
  int leng;

  _onEntryAdded(Event event) {
    setState(() {
      itemsHis.add(ItemHis.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = itemsHis.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      itemsHis[itemsHis.indexOf(old)] = ItemHis.fromSnapshot(event.snapshot);
    });
  }

  @override
  void initState() {
    super.initState();
    _postCount = widget.number;
    _postKey = widget.keyProduct;
    _productName = widget.name;
    _oldPostCount = widget.number;
    _historyProduct = widget.historyProduct;
    _postImage = widget.image;
    itemHis = ItemHis("");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    itemRefHis = database.reference().child('items/$_postKey/history');
    itemRefHis.onChildAdded.listen(_onEntryAdded);
    itemRefHis.onChildChanged.listen(_onEntryChanged);
    // FirebaseDatabase.instance.reference().child('items/$_postKey/history').onChildAdded.listen(_editHistory);
  }

  List<String> history = ["cef", "cak cak"];
  @override
  Widget build(BuildContext context) {
    leng = itemsHis.length;
    print('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb$leng');
    String historyString =
        "${widget.user.displayName} đã thay đổi số lượng từ $_oldPostCount thành $_postCount";

    Widget editContainer = SliverToBoxAdapter(
      child: Text("data"),
      
    );
    var appbar = SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text("$_productName : $_oldPostCount"),
        background: Image.network(_postImage, fit: BoxFit.contain),
      ),
    );

    var listHistory = SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        if (index < leng)
          return Container(
            child: ListTile(
              title: Center(
                  child: Text(
                itemsHis[leng - index - 1].history,
                style: TextStyle(fontSize: 13.0),
              )),
            ),
          );
      }),
    );

    var edit = SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text('Tên sản phẩm: $_productName',
                    style: TextStyle(fontSize: 20.0))),
            Container(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text('Số lượng: $_oldPostCount')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.only(right: 0.0, left: 10.0),
                  child: Text(
                    "-",
                    style: TextStyle(fontSize: 40.0),
                  ),
                  onPressed: () => setState(() => _postCount = _postCount - 1),
                ),
                Container(
                  padding: EdgeInsets.only(right: 25.0),
                  child: Text(_postCount.toString()),
                ),
                IconButton(
                  padding: EdgeInsets.only(right: 15.0),
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _postCount = _postCount + 1;
                    });
                  },
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 15.0),
              height: 50.0,
              child: FlatButton(
                color: Colors.red[200],
                child: Text("Submit"),
                onPressed: () {
                  FirebaseDatabase.instance
                      .reference()
                      .child("items/$_postKey/number")
                      .set(_postCount);
                  print(historyString);
                  history.add(historyString);
                  if (_oldPostCount != _postCount) {
                    FirebaseDatabase.instance
                        .reference()
                        .child("items/$_postKey/history")
                        .push()
                        .set(historyString);
                    _oldPostCount = _postCount;
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 50.0),
              child: Text("Lịch sử chỉnh sửa:"),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          appbar, //image appbar
          edit, //edit button
          // editContainer,
          listHistory //list of history edit
        ],
      ),
    );
  }
}
