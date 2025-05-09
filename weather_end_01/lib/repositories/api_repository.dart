import 'package:dio/dio.dart';
import 'package:weather_zenvn/apps/utils/const.dart';
import 'package:weather_zenvn/models/weather.dart';

class ApiRepository {
  static Future<WeatherData> callApiGetWeather() async {
    try {
      final dio = Dio();
      final res = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=10,77585&lon=106,75467&units=metric&appid=${MyKey.api_token}',
      );
      final data = res.data;
      WeatherData result = WeatherData.fromMap(data);
      return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
