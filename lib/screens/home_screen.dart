import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import 'search_screen.dart';
import 'forecast_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WeatherHomeTab(),
    const ForecastScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Forecast'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class WeatherHomeTab extends StatelessWidget {
  const WeatherHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text(provider.error!))
              : provider.currentWeather == null
                  ? const Center(child: Text('Search for a city'))
                  : _buildWeatherCard(context, provider),
    );
  }

  Widget _buildWeatherCard(BuildContext context, WeatherProvider provider) {
    final weather = provider.currentWeather!;
    final temp = provider.isCelsius ? weather.temp : (weather.temp * 9/5 + 32);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    weather.city,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Image.network(
                    'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
                    height: 100,
                  ),
                  Text(
                    '${temp.toStringAsFixed(1)}°${provider.isCelsius ? 'C' : 'F'}',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    weather.description.toUpperCase(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '${weather.humidity}%',
                      ),
                      _InfoItem(
                        icon: Icons.air,
                        label: 'Wind',
                        value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              if (provider.isFavorite(weather.city)) {
                provider.removeFavorite(weather.city);
              } else {
                provider.addFavorite(weather.city);
              }
            },
            icon: Icon(provider.isFavorite(weather.city) ? Icons.favorite : Icons.favorite_border),
            label: Text(provider.isFavorite(weather.city) ? 'Remove from Favorites' : 'Add to Favorites'),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}