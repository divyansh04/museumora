import 'package:flutter/material.dart';
import 'package:museumora/screens/virtual_tour/core/floorplan_model.dart';
import 'package:museumora/screens/virtual_tour/global.dart';
import 'package:provider/provider.dart';

class ResetButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FloorPlanModel>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          shape: StadiumBorder(),
          elevation: 5.0,
          color: Global.blue,
          onPressed: () {
            model.reset();
          },
          child: Icon(
            Icons.zoom_out_map,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
