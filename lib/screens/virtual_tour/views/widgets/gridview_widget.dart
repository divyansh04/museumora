import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:museumora/screens/virtual_tour/core/floorplan_model.dart';
import 'package:museumora/screens/virtual_tour/core/models.dart';
import 'package:museumora/screens/virtual_tour/global.dart';
import 'package:provider/provider.dart';

class GridViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final model = Provider.of<FloorPlanModel>(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //crossAxisSpacing: 2.0,
        //mainAxisSpacing: 2.0,
        crossAxisCount: 3,
      ),
      itemCount: 9,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        int currentTile = index + 1;
        List<Room> tileLights =
            model.rooms.where((item) => item.tile == currentTile).toList();

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              color: Global.blue,
              child: Image.asset(
                'assets/images/tile_0$currentTile.png',
              ),
            ),
            Stack(
              children: List.generate(
                tileLights.length,
                (idx) {
                  return Transform.translate(
                    offset: Offset(
                      size.width * tileLights[idx].position[0],
                      size.width * tileLights[idx].position[1],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundColor: tileLights[idx].status
                              ? Colors.greenAccent
                              : Colors.white,
                          radius: 5.0,
                          child: Center(
                            child: Icon(
                              Icons.lightbulb_outline,
                              color: Global.blue,
                              size: 7,
                            ),
                          ),
                        ),
                        Transform(
                          transform: Matrix4.identity()..translate(20.0),
                          child: Text(
                            tileLights[idx].name,
                            style: TextStyle(
                              fontSize: 6.0,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
            // model.isScaled
            //     ? Stack(
            //         children: List.generate(
            //           tileLights.length,
            //           (idx) {
            //             return Transform.translate(
            //               offset: Offset(
            //                 size.width * tileLights[idx].position[0],
            //                 size.width * tileLights[idx].position[1],
            //               ),
            //               child: Stack(
            //                 alignment: Alignment.center,
            //                 children: <Widget>[
            //                   new InkWell(
            //                     onTap: () {
            //                       Navigator.push(
            //                           context,
            //                           MaterialPageRoute(
            //                               builder: (context) =>
            //                                   detailScreen()));
            //                     },
            //                     child: new CircleAvatar(
            //                       backgroundColor: tileLights[idx].status
            //                           ? Colors.greenAccent
            //                           : Colors.white,
            //                       radius: 5.0,
            //                       child: Center(
            //                         child: Icon(
            //                           Icons.lightbulb_outline,
            //                           color: Global.blue,
            //                           size: 7,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   Transform(
            //                     transform: Matrix4.identity()..translate(20.0),
            //                     child: Text(
            //                       tileLights[idx].name,
            //                       style: TextStyle(
            //                         fontSize: 6.0,
            //                         color: Colors.white,
            //                       ),
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             );
            //           },
            //         ),
            //       )
            //     : CircleAvatar(
            //         backgroundColor: Colors.white,
            //         child: Text(
            //           '${tileLights.length}',
            //           style: TextStyle(
            //             color: Global.blue,
            //           ),
            //         ),
            //       ),
          ],
        );
      },
    );
  }
}
