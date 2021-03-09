import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:museumora/screens/dashboard/dashboard.dart';
import 'package:museumora/screens/virtual_tour/core/floorplan_model.dart';
import 'package:museumora/services/serviceLocator.dart';
import 'package:provider/provider.dart';

import 'config/palette.dart';
import 'screens/splash.dart';
import 'services/moduleServices/userServices.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FloorPlanModel>(
            create: (context) => FloorPlanModel()),
      ],
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

        home: Dashboard(),
        // SplashScreen(),

        //home: const SplashScreen(),
      ),
    );
  }
}
