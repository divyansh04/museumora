import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../networkEngine.dart';

class UserService {
  //Maintain a global variable throughout the app
  User user;

  //Get the user from authentication
  //For authentication

  bool hasEmail;

  //token for FCM
  String tokenId;

  UserService() {
    _listenToAuthStateChanged();
  }

  void _listenToAuthStateChanged() {
    FirebaseAuth.instance.authStateChanges().listen((userEvent) {
      this.user = userEvent;
    });
  }

  Future<User> getAuthUser() async {
    this.user = FirebaseAuth.instance.currentUser;
    setUser(this.user);
    return this.user;
  }

  void setUser(User user) {
    this.user = user;
    if (this.user != null) {
      this.hasEmail = this.user.email != null && this.user.email.isNotEmpty;
      // this.user.getIdToken().then((value) => print('Toen Id: ' + value.token.toString()));
    }
  }

  User getUser() {
    return this.user;
  }

  //logout User from the app
  logoutUser() async {
    this.user = null;
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
