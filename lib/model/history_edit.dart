import 'package:firebase_database/firebase_database.dart';

class ItemHis {
  String key;
  String history;

  ItemHis(this.history);

  ItemHis.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        history = snapshot.value;

  // toJson() {
  //   return {
  //     "history" : history
  //   };
  // }
}
