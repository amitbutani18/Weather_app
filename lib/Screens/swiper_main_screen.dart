import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:weather_app/Screens/custom_weather_screen.dart';
import 'package:weather_app/Screens/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwiperMainScreen extends StatelessWidget {
  SwiperController controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: 300.h,
      child: Swiper(
        itemCount: 5,
        // autoplay: true,
        scrollDirection: Axis.vertical,
        index: 0,
        controller: controller,
        itemBuilder: (context, index) {
          if (index == 0) {
            return HomeScreen();
          } else if (index == 1) {
            return CustomWeatherScreen(
              cityName: "America",
            );
          } else if (index == 2) {
            return CustomWeatherScreen(
              cityName: "Delhi",
            );
          } else if (index == 3) {
            return CustomWeatherScreen(
              cityName: "London",
            );
          } else if (index == 4) {
            return CustomWeatherScreen(
              cityName: "Canada",
            );
          }
          return Container();
        },
        // pagination: new SwiperPagination(
        //     margin: new EdgeInsets.all(5.0),
        //     builder: new DotSwiperPaginationBuilder(
        //         size: 5,
        //         activeSize: 5,
        //         color: Colors.white,
        //         activeColor: Colors.red)),
      ),
    );
  }
}
