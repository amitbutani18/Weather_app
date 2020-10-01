import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Helpers/weather.dart';

class GetPosition {
  static final GetPosition _singleton = GetPosition._internal();
  factory GetPosition() => _singleton;
  GetPosition._internal();
  static GetPosition get shared => _singleton;

  Future<Weather> getPosition() async {
    try {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
      print(position.longitude);
      final response1 = await http.get(
          "http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=d209c7c2dd01744b5c49c851441283ea");
      Map map = json.decode(response1.body);
      print(map);

      if (map.containsKey('message')) {
        print("map['message']");
        throw map['message'];
      } else {
        if (map['cod'] == 200) {
          final weatherGenerater = Weather.fromJson(map);
          print(weatherGenerater.temperature);
          return weatherGenerater;
        }
      }
    } catch (e) {
      print("Error" + e);
      throw e;
    }
  }
}
