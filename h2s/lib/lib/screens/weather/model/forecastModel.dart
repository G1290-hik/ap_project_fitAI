import 'package:h2s/screens/weather/model/weatherModel.dart';

class ForecastData {
  final List<WeatherData> list;

  ForecastData({required this.list});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    List<WeatherData> weatherList = [];

    for (dynamic e in json['list']) {
      WeatherData w = WeatherData(
        date: DateTime.fromMillisecondsSinceEpoch(e['dt'] * 1000, isUtc: false),
        name: json['city']['name'],
        temp: e['main']['temp'].toDouble(),
        main: e['weather'][0]['main'],
        icon: e['weather'][0]['icon'],
      );
      weatherList.add(w);
    }

    return ForecastData(
      list: weatherList,
    );
  }
}
