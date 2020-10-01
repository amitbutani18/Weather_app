import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class GetPosition {
  static final GetPosition _singleton = GetPosition._internal();
  factory GetPosition() => _singleton;
  GetPosition._internal();
  static GetPosition get shared => _singleton;

  Future<Weather> getPosition() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    WeatherFactory wf = new WeatherFactory("d209c7c2dd01744b5c49c851441283ea");
    Weather w = await wf.currentWeatherByLocation(
        position.latitude, position.longitude);
    print(w);
    return w;
  }
}
