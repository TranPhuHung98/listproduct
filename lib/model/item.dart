import 'package:firebase_database/firebase_database.dart';

class Item {
  String key;
  String image;
  String name;
  int number;
  // String

  Item(this.image, this.name, this.number);

  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        image = snapshot.value["image"],
        name = snapshot.value["name"],
        number = snapshot.value["number"];

  // toJson() {
  //   return {
  //     "image": image,
  //     "name": name,
  //     "number": number,
  //   };
  // }
}
