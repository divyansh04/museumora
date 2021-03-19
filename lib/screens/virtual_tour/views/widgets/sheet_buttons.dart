import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museumora/screens/virtual_tour/core/floorplan_model.dart';
import 'package:museumora/screens/virtual_tour/views/screens/room.dart';
import 'package:provider/provider.dart';

class SheetButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FloorPlanModel>(context);
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: model.rooms.map((e) {
        return ResultTile(e, context);
      }).toList(),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ResultTile(element, context) {
    return Card(
        child: ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewRoom(
                      room: element,
                    )));
      },
      leading: Icon(Icons.meeting_room_outlined),
      title: Text(
        element.location,
        style: TextStyle(fontSize: 20),
      ),
    ));
  }
}
