import 'package:flutter/material.dart';
import 'package:museumora/screens/dashboard/widgets/tabs.dart';

import 'widgets/custom_drawer.dart';
import 'widgets/exhibition_bottom_sheet.dart';
import 'home_page.dart';
import 'widgets/sliding_cards.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key key}) : super(key: key);
  static MaterialPageRoute get route => MaterialPageRoute(
        builder: (context) => const Dashboard(),
      );

  @override
  Widget build(context) {
    return CustomDrawer(child: HomePage());
  }
}
