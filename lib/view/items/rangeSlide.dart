import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';


class RSlider extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return RSliderState();
  }
}
class RSliderState extends State<StatefulWidget>{

  SfRangeValues _values = SfRangeValues(0, 1535500);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SfRangeSliderTheme(
          data: SfRangeSliderThemeData(
            activeTrackHeight: 6,
            inactiveTrackHeight: 6,
            activeDividerRadius:7,
            inactiveDividerRadius: 7,
            activeDividerStrokeColor: Colors.green,
            activeDividerStrokeWidth: 2,
            inactiveDividerStrokeWidth: 2,
            inactiveDividerStrokeColor: Colors.white,
            thumbRadius: 0,
          ),
          child: SfRangeSlider(

            min: 0.0,
            max: 10000000.0,
            values: _values,
            interval: 5000000.0,
            showLabels: true,
            showDividers: true,
            activeColor: Colors.green,
            onChanged: (SfRangeValues newValues) {
              //   setState(() {
              //     _values = newValues;
              //   });
            },
          ),

        )

    );



  }
}
