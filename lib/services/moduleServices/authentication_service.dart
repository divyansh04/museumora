import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:museumora/services/moduleServices/userServices.dart';
import 'package:museumora/services/serviceLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { AUTHENTICATED, NO_PHONE_AUTH, NO_EMAIL_AUTH, NO_AUTH }

class AuthenticationService {
  ///
  /// Checks if the user has logged in correctly with 2 authentication
  /// If user has email and phone number, it directs user to Dashboard
  /// otherwise returns current AuthStatus
  ///
  Future<AuthStatus> logUserIntoApp(BuildContext context,
      {bool newAccount = true}) async {
    User user = await use.get<UserService>().getAuthUser();
    if (user == null) {
      return AuthStatus.NO_AUTH;
    } else if (user.email == null) {
      return AuthStatus.NO_EMAIL_AUTH;
    } else if (user.phoneNumber == null) {
      return AuthStatus.NO_PHONE_AUTH;
    } else {
      // await _giveAccess(context, createEntry: newAccount);
      return AuthStatus.AUTHENTICATED;
    }
  }

  // Future<void> _giveAccess(BuildContext context,
  //     {bool createEntry = true}) async {
  //   String userId = use.get<UserService>().user.uid;
  //   // if (createEntry) {
  //   String notificationId = await FirebaseMessaging().getToken();
  //   await use
  //       .get<UserService>()
  //       .addUserToDB(userId, notificationId: notificationId);
  //   // }
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String lastUser;
  //   try {
  //     lastUser = prefs.getString('lastUser');
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   try {
  //     //If 1st time login in device
  //     //If not 1st time but not the last user
  //     if (lastUser == null || lastUser != userId) {
  //       //if previous user is different than current user
  //       if (lastUser != null) {
  //         await use.get<RepoService>().deleteDB();
  //       }
  //       await use.get<RepoService>().createDB();

  //       await prefs.setString('lastUser', userId);
  //     }
  //     List<Map<String, dynamic>> list =
  //         await use.get<FlightService>().getUserFlights();
  //     await use.get<RepoService>().saveContent("FLIGHTS", list);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   Navigator.popUntil(context, (route) => route.isFirst);
  //   Navigator.pushReplacementNamed(context, Dashboard.routeName,
  //       arguments: Dashboard());
  // }

  ///
  /// Adds Name, Email & Password to the current user
  ///
  Future<String> createPassword(
      String name, String email, String password) async {
    User user = use.get<UserService>().user;
    String errorMessage;
    try {
      await user.updateEmail(email);
      await user.updatePassword(password);
      await user.updateProfile(displayName: name);
      use.get<UserService>().setUser(user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Your password is still weak';
          break;
        case 'requires-recent-login':
          errorMessage = 'Session expired! Please complete the process again';
          break;
        case 'invalid-emai;':
          errorMessage = 'Email address is not correct';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email is already in use';
          break;
        default:
          errorMessage = 'Opps! Some error occurred';
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    } else {
      return 'success';
    }
  }

  ///
  /// Sign in by email or phone and  password
  ///
  Future<String> logInUser(String emailPhone, String password) async {
    // Assigns email's initial value
    String email = emailPhone;
    // Check if emailPhone is a email or phone
    final bool isValidEmail = EmailValidator.validate(emailPhone);
    // If the value is not email
    if (!isValidEmail) {
      // Replace spaces
      emailPhone = emailPhone.replaceAll(" ", "");
      if (!emailPhone.startsWith('+')) {
        return "You need to enter county code.";
      }
      try {
        // Get the email from the phone number.
        String result =
            await use.get<UserService>().getEmailFromPhone(emailPhone);
        email = result;
        // If no email is found
        if (email == null || !EmailValidator.validate(email)) {
          return 'Email/Phone you have entered is incorrect.';
        }
      } catch (e) {
        // If an API call error occurs
        return 'Oops! There seems to be an error. Please try again.';
      }
    }
    // Call log In with email
    return await _logInWithEmail(email, password);
  }

  ///
  /// Logs in user with his email and password.
  ///
  Future<String> _logInWithEmail(String email, String password) async {
    String errorMessage;
    try {
      UserCredential userCredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredentials.user.phoneNumber == null) {
        return "PHONE_NOT_REGISTERED_ERROR";
      }
      use.get<UserService>().setUser(userCredentials.user);
    } on FirebaseAuthException catch (e) {
      //Auth failed
      print(e.code);
      switch (e.code) {
        case 'invalid-email':
          errorMessage = "Your email address appears to be malformed.";
          break;
        case 'wrong-password':
          errorMessage = "Your password is wrong.";
          break;
        case 'user-not-found':
          errorMessage = "User with this email doesn't exist.";
          break;
        case 'user-disabled':
          errorMessage = "User with this email has been disabled.";
          break;
        // case 'ERROR_TOO_MANY_REQUESTS':
        //   errorMessage = "Too many requests. Try again later.";
        //   break;
        // case 'ERROR_OPERATION_NOT_ALLOWED':
        //   errorMessage = "Signing in with Email and Password is not enabled.";
        //   break;
        default:
          errorMessage = 'Oops! Please enter the correct credentials.';
      }
    } catch (e) {
      errorMessage = 'Seems like you entered wrong credentials';
    }
    if (errorMessage != null) {
      return errorMessage;
    } else {
      return 'success';
    }
  }

  ///
  /// Sign In User via google
  ///
  Future<String> signInWithGoogle() async {
    String errorMessage;
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return 'Sign-in Aborted';
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      use.get<UserService>().setUser(result.user);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.code;
    } catch (e) {
      errorMessage = 'There was some error in sign-in with google.';
    }
    if (errorMessage != null) {
      return errorMessage;
    } else {
      return 'success';
    }
  }

  ///
  /// Checks if a given phone number is related to some account
  /// If it exists, This returns the email related to that phone number.
  ///
  /// Returns a map with key `exists` as true or false
  ///
  /// If `exists` is true, contains the `email` attribute
  ///
  Future<Map<String, dynamic>> checkIfPhoneExists(String phone) async {
    String val = await use.get<UserService>().getEmailFromPhone(phone);
    print('checkIfPhoneExists: $val');
    if (val == null || val.isEmpty) {
      return {'exists': false};
    }
    return {'exists': true, 'email': val};
  }

  Future<String> checkIfEmailExists(String email) async {
    try {
      List<String> providers =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (providers != null && providers.isNotEmpty) {
        return "Email already exists";
      } else {
        return "success";
      }
    } catch (e) {
      print(e.toString());
      if (e.code == "invalid-email") {
        return "Incorrect mail address entered";
      } else {
        return e.toString();
      }
    }
  }
}
