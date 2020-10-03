import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainTemp extends StatelessWidget {
  final temp;
  final iconData;
  final weather;
  final maxTemp;
  final minTemp;

  const MainTemp(
      {Key key,
      this.temp,
      this.iconData,
      this.weather,
      this.maxTemp,
      this.minTemp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${(temp).toStringAsFixed(0)}°",
          style: TextStyle(
            fontFamily: 'Quicksand',
            color: Colors.white,
            fontSize: 140.ssp,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 35.h,
              width: 35.w,
              child: Icon(
                iconData,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 50.w,
            ),
            Text(
              weather,
              style: TextStyle(
                fontFamily: 'Quicksand',
                color: Colors.white,
                fontSize: 35.ssp,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            Icon(
              Icons.arrow_upward,
              color: Colors.green,
              size: 25.ssp,
            ),
            Text(
              maxTemp.toStringAsFixed(2),
              style: TextStyle(color: Colors.white, fontSize: 22.ssp),
            ),
            SizedBox(
              width: 20.w,
            ),
            Icon(
              Icons.arrow_downward,
              color: Colors.red,
              size: 25.ssp,
            ),
            Text(
              minTemp.toStringAsFixed(2),
              style: TextStyle(color: Colors.white, fontSize: 22.ssp),
            ),
          ],
        ),
        // SizedBox(
        //   height: 20,
        // ),
        // Divider(
        //   color: Colors.white54,
        //   indent: 10,
        // ),
      ],
    );
  }
}
