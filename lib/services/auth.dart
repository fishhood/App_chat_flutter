import 'package:chat_app_tutorial/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../view/chatRoomsScreen.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User user) {
    return user != null ? UserModel(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user!;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future singUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user!;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }

    Future resetPassword(String email) async {
      try {
        return await _auth.sendPasswordResetEmail(email: email);
      } catch (e) {
        print(e.toString());
      }
      Future signOut() async {
        try {
          return await _auth.signOut();
        } catch (e) {}
      }
    }
  }

  void signOut() {}
}

class AuthService {
  Future<User?> signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    final GoogleSignInAccount? _googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await _googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if (result == null) {
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatRoom(
                    userEmail: userDetails?.email ?? "",
                    username: userDetails?.displayName ?? "",
                  )));
    }
    return userDetails;
  }
}
