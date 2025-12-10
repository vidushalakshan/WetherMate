import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/services/storage_service.dart';

void main() {
  setUp(() async {
    // Initialize Hive for testing
    Hive.init('test/hive_db'); 
    // Mock the box or open a temporary box for testing
    // Since we can't easily mock Hive.initFlutter() in unit tests without more setup,
    // we might need to adjust how we test MyApp if it calls Hive.initFlutter() in main().
    // However, MyApp itself is a widget, so we can test it if we mock the dependencies or initialize what's needed.
  });

  testWidgets('App renders Home Screen', (WidgetTester tester) async {
    // We need to handle the Hive initialization that main() usually does,
    // or we need to mock the box opening if MyApp calls it.
    // However, looking at main.dart, Hive.initFlutter() and openBox are called in main(), not inside MyApp.
    // So MyApp just expects the box to be open if any widget inside uses it immediately.
    // The WeatherProvider uses StorageService which uses Hive.box('favorites').
    
    // So we need to open the box 'favorites' before pumping MyApp.
    // We need to make sure Hive is initialized for the test environment.
    // Note: Hive.initFlutter() depends on path_provider which might need platform channels.
    // For widget tests, using Hive.init(path) is often safer if possible, or mocking.

    // Let's try to simulate the environment
    final path = 'test/hive_testing_path';
    Hive.init(path);
    if (!Hive.isBoxOpen('favorites')) {
      await Hive.openBox('favorites');
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the Home Screen or basic UI structure is present.
    // HomeScreen has a title 'Weather App' in the AppBar.
    expect(find.text('Weather App'), findsOneWidget);
    
    // Verify that "Search for a city" text is present (initial state)
    expect(find.text('Search for a city'), findsOneWidget);

    // Clean up
    await Hive.deleteFromDisk();
  });
}
