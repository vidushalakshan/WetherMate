import 'package:dio/dio.dart';
import '../models/weather.dart';
import '../models/forecast.dart';

class WeatherService {
  final String apiKey = '3fbc8166bde7408318a3f6f8fd73724a';
  final Dio dio = Dio();

  Future<Weather> getWeather(String city) async {
    try {
      print(' Fetching weather for: $city');

      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      print('Weather API Response: ${response.statusCode}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        return Weather.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather');
      }
    } on DioException catch (e) {
      print('API Error: ${e.message}'); // Debug
      if (e.response?.statusCode == 404) {
        throw Exception('City not found');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Invalid API key');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('Error: $e'); // Debug
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<Forecast>> getForecast(String city) async {
    try {
      print('Fetching forecast for: $city');

      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/forecast',
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      print('Forecast API Response: ${response.statusCode}'); // Debug

      if (response.statusCode == 200) {
        final List data = response.data['list'];
        List<Forecast> forecasts = [];
        for (int i = 0; i < data.length && forecasts.length < 7; i += 8) {
          forecasts.add(Forecast.fromJson(data[i]));
        }
        return forecasts;
      } else {
        throw Exception('Failed to load forecast');
      }
    } on DioException catch (e) {
      print('Forecast Error: ${e.message}');
      throw Exception('Failed to load forecast: ${e.message}');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}