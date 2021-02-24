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
  bool hasNumber;
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
      this.hasNumber =
          this.user.phoneNumber != null && this.user.phoneNumber.isNotEmpty;
      this.hasEmail = this.user.email != null && this.user.email.isNotEmpty;
      // this.user.getIdToken().then((value) => print('Toen Id: ' + value.token.toString()));
    }
  }

  User getUser() {
    return this.user;
  }

  // Future<void> updateNotificationToken(String notificationId) async {
  //   if (user != null) {
  //     await addUserToDB(user.uid, notificationId: notificationId);
  //   }
  // }

  //Add user details to Firebase Database
  // Future<dynamic> addUserToDB(String userUid, {String notificationId}) async {
  //   var response = Response();

  //   var payload = {'userId': userUid.toString()};
  //   if (notificationId != null || tokenId != null) {
  //     payload['mToken'] = notificationId ?? tokenId;
  //     payload['device_id'] = await _getId();
  //     // print("device_Id: " + payload['device_id']);
  //   }
  //   try {
  //     response = await NetworkEngine().dio.post(addUser, data: payload);
  //   } catch (e) {
  //     return e.message;
  //   }
  //   return response.data;
  // }

  Future<String> getEmailFromPhone(String phone) async {
    String email;
    // try {
    //   final value = await NetworkEngine().dio.get(getEmailFromPhoneApi + phone);
    //   if (value.data is Map<String, dynamic>) {
    //     throw 'No Email exists with this phone';
    //   }
    //   email = value.data as String;
    // } catch (e) {
    //   print("getEmailFromPhone " + e.toString());
    // }
    return email;
  }

  // Future<bool> updateUser(dynamic payload, String userId) async {
  //   try {
  //     final response = await NetworkEngine()
  //         .dio
  //         .put(updateUserDetailApi + userId, data: payload);
  //   } catch (e) {
  //     return false;
  //   }
  //   return true;
  // }

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
