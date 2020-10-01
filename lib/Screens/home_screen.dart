import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Api/apicall.dart';
import 'package:weather_app/Api/get_position.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Animation<double> _fadeAnimation, _btnFadeAnimation;
  AnimationController _animationController, _btnAnimationController;
  Animation<Offset> _offsetAnimation;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textEditingController;
  bool _search = false, _isLoad = false, _isInit = true;
  int _temp = 0, _maxTemp, _minTemp;
  String _cityName = 'Your City';
  int _humidity = 0;
  double _wind = 0.0;

  @override
  void initState() {
    super.initState();
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
    textEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoad = true;
      });

      final response = await GetPosition.shared.getPosition();
      setState(() {
        _isLoad = false;
        _cityName = response.areaName;
        _temp = response.temperature.celsius.round();
        _maxTemp = response.tempMax.celsius.round();
        _minTemp = response.tempMin.celsius.round();
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/snowBackground.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: Colors.black54,
        body: _isLoad
            ? spinkit
            : Padding(
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
                                            final response =
                                                await ApiCall.shared.call(
                                                    textEditingController.text);
                                            setState(() {
                                              _cityName =
                                                  textEditingController.text;
                                              textEditingController.clear();
                                              _isLoad = false;
                                              double temp =
                                                  response['temp'] - 273.15;
                                              double maxTemp =
                                                  response['temp_max'] - 273.15;
                                              double minTemp =
                                                  response['temp_min'] - 273.15;

                                              _temp = temp.round();
                                              _maxTemp = maxTemp.round();
                                              _minTemp = minTemp.round();
                                              _humidity = response['humidity'];
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
                      height: 150.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_temp.round()}°",
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            color: Colors.white,
                            fontSize: 140.ssp,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 35.h,
                              width: 35.w,
                              child: Image.asset('assets/icons/snow.png'),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Text(
                              "Snowing",
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
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.green,
                              size: 25,
                            ),
                            Text(
                              _maxTemp.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.red,
                              size: 25,
                            ),
                            Text(
                              _minTemp.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          ],
                        )
                      ],
                    ),
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
                          padding: const EdgeInsets.only(left: 18.0, right: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BottomDetails(
                                title: 'Wind',
                                para: "km/h",
                                value: 13,
                              ),
                              BottomDetails(
                                title: 'Rain',
                                para: "%",
                                value: 0,
                              ),
                              BottomDetails(
                                title: 'Humidity',
                                para: "%",
                                value: _humidity,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  customSnackbar(String msg) {
    return _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[100],
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
