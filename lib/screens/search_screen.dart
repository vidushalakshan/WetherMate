import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search City')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.search),
              ),
              onSubmitted: (value) => _search(context),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _search(context),
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  void _search(BuildContext context) async {
    if (_controller.text.isNotEmpty) {
      await context.read<WeatherProvider>().fetchWeather(_controller.text);
      Navigator.pop(context);
    }
  }
}