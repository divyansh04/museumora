import 'package:flutter/material.dart';
import 'package:museumora/screens/dashboard/widgets/sliding_cards.dart';
import 'package:museumora/screens/dashboard/widgets/tabs.dart';
import 'package:museumora/screens/nearby_interface.dart';

import 'widgets/custom_drawer.dart';
import 'widgets/exhibition_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Header(),
                SizedBox(height: 40),
                Tabs(),
                SizedBox(height: 8),
                SlidingCardsView(),
              ],
            ),
          ),
          ExhibitionBottomSheet(), //use this or ScrollableExhibitionSheet
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () => CustomDrawer.of(context).open(),
              );
            },
          ),
          Text(
            'Museumora',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(
                  Icons.people_alt_outlined,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.push(context,MaterialPageRoute(
                  builder: (context){
                    return NearbyInterface();
                  }
                )),
              );
            },
          ),
        ],
      ),
    );
  }
}
