import 'package:flutter/material.dart';
import 'package:weather_app/Helpers/weather.dart';
import 'package:charts_flutter/flutter.dart' as chart;

class ForcastChart extends StatelessWidget {
  final List<Weather> forcast;

  const ForcastChart({Key key, this.forcast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: chart.TimeSeriesChart(
            [
              chart.Series<Weather, DateTime>(
                id: 'Temperature',
                colorFn: (datum, index) => chart.MaterialPalette.black,
                domainFn: (Weather weather, _) =>
                    DateTime.fromMillisecondsSinceEpoch(weather.time * 1000),
                measureFn: (Weather weather, _) => weather.temperature.celsius,
                data: forcast,
              )
            ],
          ),
        ),
      ),
    );
  }
}
