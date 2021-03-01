import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:museumora/services/moduleServices/userServices.dart';
import 'package:museumora/services/serviceLocator.dart';
import 'package:museumora/utilities/route_generator.dart';

import 'screens/dashboard/dashboard.dart';
import 'screens/signIn/auth_initial_screen.dart';

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
  if (use.get<UserService>().getUser() != null && !use.get<UserService>().hasEmail) {
    await use.get<UserService>().logoutUser();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final String initialWidgetRoute = use.get<UserService>().getUser() != null
        ? Dashboard.routeName
        // : (isOnBoardingVisited
        //     ?
        : AuthInitialScreen.routeName;
    // : OnBoardingScreen.routeName);
    return MaterialApp(
      // theme: ThemeData(
      //   // This is the theme of your application.
      //   //
      //   // Try running your application with "flutter run". You'll see the
      //   // application has a blue toolbar. Then, without quitting the app, try
      //   // changing the primarySwatch below to Colors.green and then invoke
      //   // "hot reload" (press "r" in the console where you ran "flutter run",
      //   // or simply save your changes to "hot reload" in a Flutter IDE).
      //   // Notice that the counter didn't reset back to zero; the application
      //   // is not restarted.
      //   primarySwatch: Colors.blue,
      //   // This makes the visual density adapt to the platform that you run
      //   // the app on. For desktop platforms, the controls will be smaller and
      //   // closer together (more dense) than on mobile platforms.
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),

      title: 'Museumora',
      debugShowCheckedModeBanner: false,
      initialRoute: initialWidgetRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
      // navigatorObservers: [
      //   FirebaseAnalyticsObserver(analytics: firebaseAnalytics)
      // ],
    );
  }
}
