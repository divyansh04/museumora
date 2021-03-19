import 'package:flutter/material.dart';
import 'package:museumora/screens/dashboard/widgets/exhibition_bottom_sheet.dart';

class FavouritesScreen extends StatelessWidget {
  final List<Event> favouritesList;

  const FavouritesScreen({Key key, this.favouritesList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
            size: 15.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Favourites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(children: favouritesList.map((e) => null).toList()),
    );
  }
}
