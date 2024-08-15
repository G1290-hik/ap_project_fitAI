import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:h2s/screens/weather/model/forecastModel.dart';
import 'package:h2s/screens/weather/model/weatherModel.dart';
import 'package:h2s/screens/weather/widgets/weather.dart';
import 'package:h2s/screens/weather/widgets/weatherItem.dart';
import 'package:http/http.dart' as http;

class WHomescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<WHomescreen> {
  bool isLoading = false;
  WeatherData? weatherData;
  ForecastData? forecastData;

  loadWeather() async {
    setState(() {
      isLoading = true;
    });

    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      print(e);
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }

    if (position != null) {
      final lat = position.latitude;
      final lon = position.longitude;

      final weatherResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?APPID=YOUR_API_KEY&lat=${lat.toString()}&lon=${lon.toString()}'));
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?APPID=YOUR_API_KEY&lat=${lat.toString()}&lon=${lon.toString()}'));

      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        setState(() {
          weatherData =
              WeatherData.fromJson(jsonDecode(weatherResponse.body));
          forecastData =
              ForecastData.fromJson(jsonDecode(forecastResponse.body));
          isLoading = false;
        });
      } else {
        // Handle API errors
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch weather data')),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      // Location fetch failed, already handled in catch block
    }
  }

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Location Weather'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : weatherData == null || forecastData == null
          ? Center(child: Text('No data available'))
          : Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Weather(weather: weatherData!),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    tooltip: 'Refresh',
                    onPressed: loadWeather,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 200.0,
                  child: ListView.builder(
                      itemCount: forecastData!.list.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => WeatherItem(
                          weather:
                          forecastData!.list.elementAt(index))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
