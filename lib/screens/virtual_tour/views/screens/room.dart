import 'package:flutter/material.dart';
import 'package:museumora/screens/virtual_tour/core/models.dart';
// import 'package:museumora/screens/virtual_tour/global.dart';
import 'package:panorama/panorama.dart';

class ViewRoom extends StatefulWidget {
  final Room room;

  const ViewRoom({Key key, this.room}) : super(key: key);
  @override
  _ViewRoomState createState() => _ViewRoomState();
}

class _ViewRoomState extends State<ViewRoom> {
  bool sensorControlled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.room.location.toString())),
      body: Stack(children: [
        Panorama(
          child: Image.asset('assets/images/rooms/${widget.room.name}.jpg'),
          sensitivity: 2.0,
          sensorControl:
              sensorControlled ? SensorControl.Orientation : SensorControl.None,
        ),
        // Positioned(
        //   right: 20,
        //   bottom: 15,
        //   child: FloatingActionButton(
        //       backgroundColor: Global.blue,
        //       heroTag: 'POI',
        //       onPressed: () {},
        //       child: Icon(
        //         Icons.photo_library_outlined,
        //         size: 30,
        //       )),
        // )
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black.withOpacity(0.2),
        onPressed: () {
          setState(() {
            sensorControlled = !sensorControlled;
          });
        },
        // mini: true,
        child: Icon(
          Icons.panorama_photosphere,
          size: 30,
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
