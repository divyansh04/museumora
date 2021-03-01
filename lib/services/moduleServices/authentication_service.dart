import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:museumora/screens/dashboard/dashboard.dart';
import 'package:museumora/services/moduleServices/userServices.dart';
import 'package:museumora/services/serviceLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { AUTHENTICATED, NO_EMAIL, NO_AUTH }

class AuthenticationService {
  Future<AuthStatus> logUserIntoApp(BuildContext context,
      {bool newAccount = true}) async {
    User user = await use.get<UserService>().getAuthUser();
    if (user == null) {
      return AuthStatus.NO_AUTH;
    } else if (user.email == null) {
      return AuthStatus.NO_EMAIL;
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, Dashboard.routeName,
          arguments: Dashboard());
      return AuthStatus.AUTHENTICATED;
    }
  }

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
  /// Sign in by email and  password
  ///
  Future<String> logInUser(String email, String password) async {
    // Check if emailPhone is a email or phone
    final bool isValidEmail = EmailValidator.validate(email);
    // If the value is not email
    if (!isValidEmail) {
      return 'Oops! There seems to be an error. Please try again.';
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
