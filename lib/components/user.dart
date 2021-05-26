import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocalUserModel {
  String id;
  String name;
  String photoUrl;

  LocalUserModel.fromFireBase(User user) {
    id = user.uid;
  }

  LocalUserModel.fromJson(Map<String, dynamic> values) {
    id = values['id'];
    name = values['name'];
    photoUrl = values['photoUrl'];
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "photoUrl": photoUrl};
  }

  LocalUserModel.fromDocument(DocumentSnapshot document) {
    id = document['id'];
    name = document['name'];
    photoUrl = document['photoUrl'];
  }
}
