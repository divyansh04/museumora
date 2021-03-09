import 'package:flutter/material.dart';
// import 'package:museumora/screens/virtual_tour/global.dart';

class AppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Color(0xFF162A49),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        'Floor Plan Screen',
        style: TextStyle(
          color: Color(0xFF162A49),
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevation: 0.0,
      bottom: PreferredSize(
        preferredSize: Size.zero,
        child: Column(
          children: <Widget>[
            Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF162A49),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
