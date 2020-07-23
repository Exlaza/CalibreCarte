import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedProgressbar extends StatelessWidget {
  final double value;
  final double height;

  AnimatedProgressbar({Key key, @required this.value, this.height = 12})
      : super(key: key);
  textScaleFactor(BuildContext context) {
    if (MediaQuery.of(context).size.height > 610) {
      return MediaQuery.of(context).textScaleFactor.clamp(0.6, 1.0);
    } else {
      return MediaQuery.of(context).textScaleFactor.clamp(0.6, 0.85);
    }
  }
  @override
  Widget build(BuildContext context) {
    ColorTheme colorTheme=Provider.of(context);
    double boxWidth = MediaQuery.of(context).size.width / 1.5;
    String percProg = (value * 100).toStringAsFixed(0) + "%";
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              textScaleFactor(context)),
      child: Container(
        width: boxWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "$percProg Downloaded",
              style: TextStyle(
                fontSize: 20,
                color: colorTheme.headerText,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                Container(
                  height: height,
                  width: boxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(height),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  height: height,
                  width: boxWidth * _floor(value),
                  decoration: BoxDecoration(
                    color: _colorGen(value),
                    borderRadius: BorderRadius.all(
                      Radius.circular(height),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Always round negative or NaNs to min value
  _floor(double value, [min = 0.0]) {
    return value.sign <= min ? min : value;
  }

  _colorGen(double value) {
    int rbg = (value * 255).toInt();
//    return Colors.deepOrange.withGreen(rbg).withRed(255 - rbg);
    return Color(0xffFED962);
  }
}
