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
              ? ExactAssetImage('assets/images/few_cloud.jpg')
              : iconId == '02d' || iconId == '03d'
                  ? ExactAssetImage('assets/images/cloudBackground.jpg')
                  : iconId == '04d' || iconId == '09d'
                      ? ExactAssetImage('assets/images/brocken_cloud.jpg')
                      : iconId == '10d'
                          ? ExactAssetImage('assets/images/rain.jpg')
                          : iconId == '11d'
                              ? ExactAssetImage('assets/images/thenderstom.jpg')
                              : iconId == '13d'
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
