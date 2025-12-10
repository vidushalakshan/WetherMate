import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('7-Day Forecast')),
      body: provider.forecasts.isEmpty
          ? const Center(child: Text('No forecast data'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.forecasts.length,
              itemBuilder: (context, index) {
                final forecast = provider.forecasts[index];
                final temp = provider.isCelsius ? forecast.temp : (forecast.temp * 9/5 + 32);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Image.network(
                      'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
                    ),
                    title: Text(DateFormat('EEE, MMM d').format(forecast.date)),
                    subtitle: Text(forecast.description),
                    trailing: Text(
                      '${temp.toStringAsFixed(1)}°${provider.isCelsius ? 'C' : 'F'}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}