import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:museumora/screens/auth/auth.dart';
import 'package:museumora/screens/auth/auth_service.dart';
import 'package:museumora/screens/dashboard/dashboard.dart';
import 'package:museumora/services/serviceLocator.dart';
import 'config/palette.dart';
import 'screens/splash.dart';
import 'services/moduleServices/userServices.dart';
AuthMethods _authMethods=AuthMethods();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Set rotation
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  // Instantiate Service Locator
  await servicesSetup();
  // FirebaseFirestore.instance.settings.persistenceEnabled = true;
  //check for user currently logged in
  await use.get<UserService>().getAuthUser();
  if (use.get<UserService>().getUser() != null &&
      !use.get<UserService>().hasEmail) {
    await use.get<UserService>().logoutUser();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

      home: FutureBuilder(
        future: _authMethods.getCurrentUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            return Dashboard();
          } else {
            return  AuthScreen();
          }
        },
      ),
      // SplashScreen(),

      //home: const SplashScreen(),
    );
  }
}
