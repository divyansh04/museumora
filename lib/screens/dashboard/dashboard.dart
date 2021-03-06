import 'package:flutter/material.dart';
import 'package:museumora/screens/SignIn/auth_initial_screen.dart';
import 'package:museumora/screens/dashboard/widgets/tabs.dart';
import 'package:museumora/services/moduleServices/userServices.dart';
import 'package:museumora/services/serviceLocator.dart';

import 'widgets/custom_drawer.dart';
import 'widgets/exhibition_bottom_sheet.dart';
import 'home_page.dart';
import 'widgets/sliding_cards.dart';

class Dashboard extends StatelessWidget {
  static const routeName = 'dashboard';
  @override
  Widget build(BuildContext context) {
    return CustomDrawer(child: HomePage());
  }
}
