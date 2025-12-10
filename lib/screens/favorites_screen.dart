import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final favorites = provider.getFavorites();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Cities')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final city = favorites[index];
                return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(city),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.removeFavorite(city),
                  ),
                  onTap: () {
                    provider.fetchWeather(city);
                    Navigator.pop(context);
                  },
                );
              },
            ),
    );
  }
}