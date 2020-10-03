import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final String iconId;
  final Widget child;
  BackgroundImage({this.iconId, this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: iconId == '01d' || iconId == '01n'
              ? ExactAssetImage(
                  'assets/images/few_cloud.jpg',
                )
              : iconId == '02d' ||
                      iconId == '03d' ||
                      iconId == '02n' ||
                      iconId == '03n'
                  ? ExactAssetImage('assets/images/cloudBackground.jpg')
                  : iconId == '04d' ||
                          iconId == '04n' ||
                          iconId == '09d' ||
                          iconId == '09n'
                      ? ExactAssetImage('assets/images/brocken_cloud.jpg')
                      : iconId == '10d' || iconId == '10n'
                          ? ExactAssetImage('assets/images/rain.jpg')
                          : iconId == '11d' || iconId == '11n'
                              ? ExactAssetImage('assets/images/thenderstom.jpg')
                              : iconId == '13d' || iconId == '13n'
                                  ? ExactAssetImage(
                                      'assets/images/snowBackground.jpg')
                                  : ExactAssetImage('assets/images/mist.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
      ),
      child: child,
    );
  }
}
