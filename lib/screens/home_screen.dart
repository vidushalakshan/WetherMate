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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2196F3),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded),
              label: 'Forecast',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherHomeTab extends StatefulWidget {
  const WeatherHomeTab({super.key});

  @override
  State<WeatherHomeTab> createState() => _WeatherHomeTabState();
}

class _WeatherHomeTabState extends State<WeatherHomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeather('Colombo');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _getGradientColors(provider.currentWeather?.description ?? ''),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Weather',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: provider.isLoading
                    ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                    : provider.error != null
                    ? _buildErrorState(context, provider)
                    : provider.currentWeather == null
                    ? _buildEmptyState(context)
                    : _buildWeatherCard(context, provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String description) {
    description = description.toLowerCase();
    if (description.contains('clear') || description.contains('sunny')) {
      return [const Color(0xFF4A90E2), const Color(0xFF50C9FF)];
    } else if (description.contains('cloud')) {
      return [const Color(0xFF5F6F81), const Color(0xFF9BAEC8)];
    } else if (description.contains('rain') || description.contains('drizzle')) {
      return [const Color(0xFF4B79A1), const Color(0xFF283E51)];
    } else if (description.contains('thunder') || description.contains('storm')) {
      return [const Color(0xFF373B44), const Color(0xFF4286f4)];
    } else {
      return [const Color(0xFF2196F3), const Color(0xFF64B5F6)];
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_outlined, size: 100, color: Colors.white.withOpacity(0.8)),
          const SizedBox(height: 20),
          Text(
            'Search for a city',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WeatherProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.white.withOpacity(0.8)),
          const SizedBox(height: 20),
          Text(
            provider.error!,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2196F3),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context, WeatherProvider provider) {
    final weather = provider.currentWeather!;
    final temp = provider.isCelsius ? weather.temp : (weather.temp * 9 / 5 + 32);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // City Name
          Text(
            weather.city,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          // Weather Icon
          Image.network(
            'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            height: 120,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.cloud, size: 120, color: Colors.white);
            },
          ),
          // Temperature
          Text(
            '${temp.toStringAsFixed(0)}°',
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          // Description
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              letterSpacing: 2,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),
          // Weather Details Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _InfoItem(
                      icon: Icons.water_drop_rounded,
                      label: 'Humidity',
                      value: '${weather.humidity}%',
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _InfoItem(
                      icon: Icons.air_rounded,
                      label: 'Wind Speed',
                      value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Favorite Button
          ElevatedButton.icon(
            onPressed: () {
              if (provider.isFavorite(weather.city)) {
                provider.removeFavorite(weather.city);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Removed from favorites'),
                    backgroundColor: Colors.red.shade400,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              } else {
                provider.addFavorite(weather.city);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Added to favorites'),
                    backgroundColor: Colors.green.shade400,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            icon: Icon(
              provider.isFavorite(weather.city)
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
            ),
            label: Text(
              provider.isFavorite(weather.city)
                  ? 'Remove from Favorites'
                  : 'Add to Favorites',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2196F3),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
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

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 35, color: Colors.white),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
