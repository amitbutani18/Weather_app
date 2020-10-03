import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Api/apicall.dart';
import 'package:weather_app/Helpers/weather.dart';
import 'package:weather_app/Widgets/background_image.dart';
import 'package:weather_app/Widgets/forecast_list.dart';
import 'package:weather_app/Widgets/page_swiper.dart';
import 'package:weather_app/Widgets/value_tile.dart';

class CustomWeatherScreen extends StatefulWidget {
  final String cityName;

  const CustomWeatherScreen({Key key, this.cityName}) : super(key: key);
  @override
  _CustomWeatherScreenState createState() => _CustomWeatherScreenState();
}

class _CustomWeatherScreenState extends State<CustomWeatherScreen>
    with TickerProviderStateMixin {
  Animation<double> _fullPageAnimation;
  AnimationController _fullPageAnimationController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoad = false, _isInit = true;
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
    _fullPageAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_fullPageAnimationController);
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoad = true;
      });

      final response = await ApiCall.shared.call(widget.cityName);
      _forcast = await ApiCall.shared.getForecast(widget.cityName);
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
}
