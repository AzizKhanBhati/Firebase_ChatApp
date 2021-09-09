import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechat/Services/database.dart';

abstract class AuthBase {
  Stream<MyUser> get onAuthChanged;
  Future<MyUser> signUpWithEmailAndPassword(String email, String password);
  Future<MyUser> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<String> updateUser(String name);
}

class AuthMethods implements AuthBase {
  DatabaseMethods databaseMethods = DatabaseMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser _userFromFirebaseUser(User user) {
    return user != null ? MyUser(userId: user.uid) : null;
  }

  Stream<MyUser> get onAuthChanged {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<MyUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<MyUser> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> updateUser(String name) async {
    final user = await _auth.currentUser;
    user.updateDisplayName(name);
    user.reload();
    return user.uid;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      e.toString();
    }
  }
}

/// model class
class MyUser {
  String userId;
  MyUser({this.userId});
}
