import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Api/apicall.dart';
import 'package:weather_app/Api/get_position.dart';
import 'package:weather_app/Helpers/weather.dart';
import 'package:weather_app/Widgets/background_image.dart';
import 'package:weather_app/Widgets/forecast_list.dart';
import 'package:weather_app/Widgets/page_swiper.dart';
import 'package:weather_app/Widgets/value_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Animation<double> _fadeAnimation, _btnFadeAnimation, _fullPageAnimation;
  AnimationController _animationController,
      _btnAnimationController,
      _fullPageAnimationController;
  Animation<Offset> _offsetAnimation;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textEditingController;
  bool _search = false, _isLoad = false, _isInit = true;
  double _temp, _maxTemp, _minTemp;
  String _cityName = 'Your City', _weather = '', _iconId = '';
  int _humidity = 0, _sunset, _sunrise;
  double _wind = 0.0;
  IconData _iconData;
  List<Weather> _forcast;

  @override
  void initState() {
    super.initState();
    _fullPageAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _btnAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _btnFadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_btnAnimationController);
    _offsetAnimation = Tween<Offset>(begin: Offset(0.0, 0.35), end: Offset.zero)
        .animate(_animationController);
    _fullPageAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_fullPageAnimationController);
    textEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoad = true;
      });

      final response = await GetPosition.shared.getPosition();
      _forcast = await ApiCall.shared.getForecast("Surat");
      // for (final x in forcast) {
      //   print(x.temperature.celsius);
      // }
      // print(forcast[0].temperature.celsius);
      setState(() {
        _isLoad = false;
        _cityName = response.cityName;
        _temp = response.temperature.celsius;
        _maxTemp = response.maxTemperature.celsius;
        _minTemp = response.minTemperature.celsius;
        _weather = response.main;
        _humidity = response.humidity;
        _wind = response.windSpeed;
        _iconId = response.iconCode;
        _iconData = response.getIconData();
        _sunset = response.sunset;
        _sunrise = response.sunrise;
        _fullPageAnimationController.forward();
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);

    final spinkit = SpinKitDoubleBounce(
      // itemBuilder: (BuildContext context, int index) {
      //   return DecoratedBox(
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //     ),
      //   );
      // },
      color: Colors.white,
      size: 50,
    );
    return BackgroundImage(
      iconId: _iconId,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: Colors.black54,
        body: _isLoad
            ? spinkit
            : FadeTransition(
                opacity: _fullPageAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _search = true;
                                _animationController.forward();
                                _btnAnimationController.forward();
                              });
                            },
                            child: _search
                                ? Container()
                                : FadeTransition(
                                    opacity: _btnFadeAnimation,
                                    child: Container(
                                      height: 45.h,
                                      width: 45.w,
                                      child: Image.asset(
                                          'assets/icons/search_icon.png'),
                                    ),
                                  ),
                          ),
                          _search
                              ? FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position: _offsetAnimation,
                                    child: Row(
                                      children: [
                                        customCitySearch(),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              _isLoad = true;
                                              _search = false;
                                              _btnAnimationController.reverse();
                                              _animationController.reverse();
                                            });
                                            try {
                                              final weatherGenerater =
                                                  await ApiCall.shared.call(
                                                      textEditingController
                                                          .text);
                                              final forcast = await ApiCall
                                                  .shared
                                                  .getForecast(
                                                      textEditingController
                                                          .text);
                                              // print(weatherGenerater.forecast[0]);
                                              setState(() {
                                                _cityName =
                                                    textEditingController.text;
                                                textEditingController.clear();

                                                _temp = weatherGenerater
                                                    .temperature.celsius;
                                                _maxTemp = weatherGenerater
                                                    .maxTemperature.celsius;
                                                _minTemp = weatherGenerater
                                                    .minTemperature.celsius;
                                                _humidity =
                                                    weatherGenerater.humidity;
                                                _wind =
                                                    weatherGenerater.windSpeed;
                                                _weather =
                                                    weatherGenerater.main;
                                                _iconId =
                                                    weatherGenerater.iconCode;
                                                _iconData = weatherGenerater
                                                    .getIconData();
                                                _forcast = forcast;
                                                _sunrise =
                                                    weatherGenerater.sunrise;
                                                _sunset =
                                                    weatherGenerater.sunset;
                                                _isLoad = false;
                                                _fullPageAnimationController
                                                    .reset();
                                                _fullPageAnimationController
                                                    .forward();
                                              });
                                            } catch (e) {
                                              print(e);
                                              setState(() {
                                                _isLoad = false;
                                              });
                                              customSnackbar(e.toString());
                                            }
                                          },
                                          child: Container(
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          _search
                              ? Container()
                              : FadeTransition(
                                  opacity: _btnFadeAnimation,
                                  child: Container(
                                    height: 45.h,
                                    width: 45.w,
                                    child: Image.asset('assets/icons/menu.png'),
                                  ),
                                ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _cityName,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              color: Colors.white,
                              fontSize: 75.ssp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "${DateFormat("dd-MMM-yyyy hh:mm:ss").format(DateTime.now())} ",
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              color: Colors.white,
                              fontSize: 25.ssp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100.h,
                      ),
                      PageSwiper(
                          temp: _temp,
                          maxTemp: _maxTemp,
                          minTemp: _minTemp,
                          weather: _weather,
                          iconData: _iconData,
                          forcast: _forcast),
                      ForecastHorizontal(weathers: _forcast),
                      Column(
                        children: [
                          Divider(
                            color: Colors.white54,
                            indent: 10,
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ValueTile("Wind speed", '$_wind m/s'),
                                ValueTile(
                                    "Sunset",
                                    DateFormat('h:m a').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            _sunrise * 1000))),
                                ValueTile(
                                    "Sunrise",
                                    DateFormat('h:m a').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            _sunset * 1000))),
                                ValueTile(
                                    "Humidity", '${_humidity.toString()} %'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  customSnackbar(String msg) {
    return _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[50],
        content: Text(
          msg,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Container customCitySearch() {
    return Container(
      width: 1.wp - 100,
      child: TextField(
        controller: textEditingController,
        cursorColor: Colors.black,
        autofocus: true,
        decoration: InputDecoration(
            filled: true,
            isDense: true,
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: "City Name",
            hintStyle: TextStyle(color: Colors.black54),
            fillColor: Colors.white38,
            contentPadding: EdgeInsets.all(10)),
      ),
    );
  }
}

class BottomDetails extends StatelessWidget {
  final String title, para;
  final int value;
  BottomDetails({
    Key key,
    this.title,
    this.para,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Quicksand',
            color: Colors.white,
            fontSize: 30.ssp,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          value.toString(),
          style: TextStyle(
            fontFamily: 'Quicksand',
            color: Colors.white,
            fontSize: 40.ssp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          para,
          style: TextStyle(
            fontFamily: 'Quicksand',
            color: Colors.white,
            fontSize: 30.ssp,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
