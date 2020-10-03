import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:weather_app/Helpers/weather.dart';
import 'package:weather_app/Widgets/forcast_chart.dart';
import 'package:weather_app/Widgets/main_temp.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageSwiper extends StatelessWidget {
  final temp;
  final iconData;
  final weather;
  final maxTemp;
  final minTemp;
  final List<Weather> forcast;

  PageSwiper(
      {Key key,
      this.temp,
      this.iconData,
      this.weather,
      this.maxTemp,
      this.minTemp,
      this.forcast})
      : super(key: key);

  final SwiperController controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height > 550 ? 400.h : 300.h,
      child: Swiper(
        itemCount: 2,
        autoplay: true,
        scrollDirection: Axis.horizontal,
        index: 0,
        controller: controller,
        fade: 0.0,

        itemBuilder: (context, index) {
          if (index == 0) {
            return MainTemp(
              temp: temp,
              maxTemp: maxTemp,
              minTemp: minTemp,
              weather: weather,
              iconData: iconData,
            );
          } else if (index == 1) {
            return ForcastChart(forcast: forcast);
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
