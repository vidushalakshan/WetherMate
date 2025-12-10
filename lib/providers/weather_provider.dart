import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storage = StorageService();

  Weather? currentWeather;
  List<Forecast> forecasts = [];
  bool isLoading = false;
  String? error;
  bool isCelsius = true;

  Future<void> fetchWeather(String city) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      currentWeather = await _weatherService.getWeather(city);
      forecasts = await _weatherService.getForecast(city);
      error = null;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleUnit() {
    isCelsius = !isCelsius;
    notifyListeners();
  }

  void addFavorite(String city) {
    _storage.addFavorite(city);
    notifyListeners();
  }

  void removeFavorite(String city) {
    _storage.removeFavorite(city);
    notifyListeners();
  }

  List<String> getFavorites() => _storage.getFavorites();
  
  bool isFavorite(String city) => _storage.isFavorite(city);
}