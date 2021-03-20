import 'package:flutter/material.dart';
import 'package:museumora/screens/virtual_tour/global.dart';

class Evac extends StatefulWidget {
  @override
  _EvacState createState() => _EvacState();
}

class _EvacState extends State<Evac> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Global.blue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/evac.jpg'),
              Text(
                "Danger ! Evacuate ASAP !",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
