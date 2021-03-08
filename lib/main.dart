import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

import 'package:museumora/screens/dashboard/dashboard.dart';

import 'config/palette.dart';
import 'screens/home.dart';
import 'screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Set rotation
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  // Instantiate Service Locator
  // await servicesSetup();
  // FirebaseFirestore.instance.settings.persistenceEnabled = true;
  //check for user currently logged in
  // await use.get<UserService>().getAuthUser();
  // if (use.get<UserService>().getUser() != null && !use.get<UserService>().hasEmail) {
  //   await use.get<UserService>().logoutUser();
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LitAuthInit(
      authProviders: const AuthProviders(
        emailAndPassword: true,
        google: true,
        apple: true,
        twitter: true,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.muliTextTheme(),
          accentColor: Palette.darkOrange,
          appBarTheme: const AppBarTheme(
            brightness: Brightness.dark,
            color: Palette.darkBlue,
          ),
        ),

        home: const LitAuthState(
          authenticated: Dashboard(),
          unauthenticated: SplashScreen(),
        ),
        //home: const SplashScreen(),
      ),
    );
  }
}
