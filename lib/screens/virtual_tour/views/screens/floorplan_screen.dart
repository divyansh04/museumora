import 'package:flutter/material.dart';
import 'package:museumora/constants.dart';
import 'package:museumora/screens/virtual_tour/core/floorplan_model.dart';
import 'package:museumora/screens/virtual_tour/global.dart';
import 'package:museumora/screens/virtual_tour/views/widgets/appbar_widget.dart';
import 'package:museumora/screens/virtual_tour/views/widgets/gridview_widget.dart';
import 'package:museumora/screens/virtual_tour/views/widgets/overlay_widget.dart';
import 'package:museumora/screens/virtual_tour/views/widgets/raw_gesture_detector_widget.dart';
import 'package:museumora/screens/virtual_tour/views/widgets/reset_button_widget.dart';
import 'package:museumora/screens/virtual_tour/views/widgets/sheet_buttons.dart';
import 'package:provider/provider.dart';

import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';

class FloorPlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FloorPlanModel>(context);

    return Scaffold(
      body: DraggableBottomSheet(
        minExtent: 100,
        maxExtent: MediaQuery.of(context).size.height * 0.6,
        previewChild: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.arrow_drop_up_rounded,
                color: Color(0xFF162A49),
                size: 30,
              ),
              Text(
                'View Exhibition Segments',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        expandedChild: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "View Segments",
                    style: TextStyle(
                      // color: Global.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down_rounded)
                ],
              ),
              Expanded(child: SheetButtons())
            ],
          ),
        ),
        backgroundWidget: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBarWidget(),
          ),
          body: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: Container(
              color: Global.blue,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  RawGestureDetectorWidget(
                    child: GridViewWidget(),
                  ),
                  model.hasTouched
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: ResetButtonWidget(),
                        )
                      : OverlayWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
