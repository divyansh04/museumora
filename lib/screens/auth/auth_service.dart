import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:museumora/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  AppUser user;
  User currentUser;
  AppUser getUser() {
    return this.user;
  }

  Future<User> getCurrentUser() async {
    this.currentUser = await  _auth.currentUser;
    return this.currentUser;
  }

  Future<AppUser> getUserDetails() async {
    this.currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
    await _firestore.collection('users').doc(currentUser.uid).get();
    return AppUser.fromMap(documentSnapshot.data());
  }

  Future<AppUser> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
      await _firestore.collection('users').doc(id).get();
      return AppUser.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
      await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      UserCredential user = await _auth.signInWithCredential(credential);
      Fluttertoast.showToast(
          msg: 'Signed in Successfully',
          textColor: Colors.black,
          backgroundColor: Colors.white);
      return user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Signed in Failed',
          textColor: Colors.black,
          backgroundColor: Colors.white);
      print("Auth methods error");
      print(e);
      return null;
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(
          msg: 'Signed Up Successfully',
          textColor: Colors.black,
          backgroundColor: Colors.white);
      return user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: '${e.toString().split(']').last}',
          textColor: Colors.black,
          backgroundColor: Colors.white);
      print("Auth methods error");
      print(e.toString());
      return null;
    }
  }

  Future<UserCredential> signIn(email, password) async {
    try {
     UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(
          msg: 'Signed In Successfully',
          textColor: Colors.black,
          backgroundColor: Colors.white);
      return user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: '${e.toString().split(']').last}',
          textColor: Colors.black,
          backgroundColor: Colors.white);
      print("Auth methods error");
      print(e.toString());
      return null;
    }
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await _firestore
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<bool> isDoctor(String id) async {
    DocumentSnapshot currentUser =
    await _firestore.collection('users').doc(id).get();
    //if user is doctor then length of list > 0 or else less than 0
    print(currentUser['userRole']);
    return currentUser['userRole'] == 'doctor' ? true : false;
  }

  Future<void> addDataToDb(User currentUser) async {
    String username = getUsername(currentUser.email);

    AppUser user = AppUser(
      uid: currentUser.uid,
      email: currentUser.email,
      username: username,
    );

    _firestore
        .collection('users')
        .doc(currentUser.uid)
        .set(user.toMap(user));
  }



  getCurrentUserDetails(String id) async {
    DocumentSnapshot currentUser =
    await _firestore.collection('users').doc(id).get();
    return currentUser;
  }


  Future<List<AppUser>> fetchAllUsers(User currentUser) async {
    List<AppUser> userList = List<AppUser>();

    QuerySnapshot querySnapshot =
    await _firestore.collection('users').get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(AppUser.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }
  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _firestore.collection('users').doc(uid).snapshots();

}