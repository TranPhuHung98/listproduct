import 'package:firebase_database/firebase_database.dart';

class Admin {
  String key;
  String admin;

  Admin(this.admin);

  Admin.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        admin = snapshot.value;
}
