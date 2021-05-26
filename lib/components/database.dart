import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instalike_flutter_project/components/post.dart';
import 'package:instalike_flutter_project/components/user.dart';

class DataBaseService {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference postCollectionReference =
      FirebaseFirestore.instance.collection('posts');

  Future createUser(LocalUserModel user) async {
    return await userCollectionReference
        .doc(user.id)
        .set(user.toMap());
  }

  Future createPost(Post post) async {
    return await postCollectionReference
        .doc(post.id)
        .set(post.toMap());
  }

  Future<LocalUserModel> getUser(String id) async {
    LocalUserModel userFromDB;
    if (id != null) {
      DocumentSnapshot snapshot =
          await userCollectionReference.doc(id).get();
      userFromDB = LocalUserModel.fromJson(snapshot.data());
      return userFromDB;
    }
    return null;
  }

  Future<String> getUserName(String id) async {
    LocalUserModel userFromDB = await getUser(id);
    if (userFromDB != null) {
      return userFromDB.name;
    }
    return null;
  }

  Future<List<Post>> getPosts() async {
    QuerySnapshot snapshot = await postCollectionReference.orderBy("timeStamp").get();
    return snapshot.docs
        .map((doc) => Post.fromJson(doc.id, doc.data()))
        .toList();
  }
}
