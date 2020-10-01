import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Helpers/weather.dart';
import 'package:weather_app/Widgets/value_tile.dart';

/// Renders a horizontal scrolling list of weather conditions
/// Used to show forecast
/// Shows DateTime, Weather Condition icon and Temperature
class ForecastHorizontal extends StatelessWidget {
  const ForecastHorizontal({
    Key key,
    @required this.weathers,
  }) : super(key: key);

  final List<Weather> weathers;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: this.weathers.length,
        itemBuilder: (context, index) {
          final item = this.weathers[index];
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 502,
              width: 90,
              child: Center(
                child: Center(
                    child: ValueTile(
                  DateFormat('E, ha').format(
                      DateTime.fromMillisecondsSinceEpoch(item.time * 1000)),
                  '${item.temperature.celsius.round()}°',
                  iconData: item.getIconData(),
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}
