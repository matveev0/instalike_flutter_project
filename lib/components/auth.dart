
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instalike_flutter_project/components/database.dart';
import 'package:instalike_flutter_project/components/user.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<LocalUserModel> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return DataBaseService().getUser(LocalUserModel.fromFireBase(user).id);
    } catch (e){
      print(e);
      return null;
    }
  }

  Future<LocalUserModel> signUpWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      DataBaseService().createUser(LocalUserModel.fromFireBase(user));
      return LocalUserModel.fromFireBase(user);
    } catch (e){
      print(e);
      return null;
    }
  }

  Future logout() async {
    await _firebaseAuth.signOut();
  }

  Stream<LocalUserModel> get currentUser{
    return _firebaseAuth.authStateChanges().map((user) => user != null ? LocalUserModel.fromFireBase(user) : null);
  }
}