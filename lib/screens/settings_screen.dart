import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Temperature Unit'),
            subtitle: Text(provider.isCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)'),
            value: provider.isCelsius,
            onChanged: (_) => provider.toggleUnit(),
          ),
        ],
      ),
    );
  }
}