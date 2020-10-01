import 'dart:convert';

import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;

class ApiCall {
  static final ApiCall _singleton = ApiCall._internal();
  factory ApiCall() => _singleton;
  ApiCall._internal();
  static ApiCall get shared => _singleton;
  var response;
  Future<Map> call(String cityName) async {
    try {
      final response1 = await http.get(
          "http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=d209c7c2dd01744b5c49c851441283ea");
      // print(json.decode(response1.body));
      Map map = json.decode(response1.body);
      print(map);
      if (map.containsKey('message')) {
        print("map['message']");
        throw map['message'];
      } else {
        if (map['cod'] == 200) {
          return map['main'];
        }
      }
      // WeatherFactory wf =
      //     new WeatherFactory("d209c7c2dd01744b5c49c851441283ea");

      // Weather w = await wf.currentWeatherByCityName(cityName);
      // print("Response" + w.toString());
      // print("w.temperature.celsius" + w.temperature.celsius.toString());
      // return w.temperature.celsius.round();
    } catch (e) {
      print("Error" + e);
      throw e;
    }
  }
}
