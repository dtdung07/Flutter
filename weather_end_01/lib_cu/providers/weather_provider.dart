import 'package:flutter/material.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/repositories/api_repository.dart';

class WeatherProvider extends ChangeNotifier {
  Future<WeatherData> getWeatherCurrent() async {
    WeatherData result = await ApiRepository.callApiGetWeather();
    return result;
  }
}
