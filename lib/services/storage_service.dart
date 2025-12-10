import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  final box = Hive.box('favorites');


  Future<void> addFavorite(String city) async {
    final cities = getFavorites();
    if (!cities.contains(city)) {
      cities.add(city);
      await box.put('cities', cities);
    }
  }


  List<String> getFavorites() {
    final data = box.get('cities', defaultValue: []);
    return List<String>.from(data);
  }


  Future<void> removeFavorite(String city) async {
    final cities = getFavorites();
    cities.remove(city);
    await box.put('cities', cities);
  }


  bool isFavorite(String city) {
    return getFavorites().contains(city);
  }
}