class Forecast {
  final DateTime date;
  final double temp;
  final String description;
  final String icon;

  Forecast({
    required this.date,
    required this.temp,
    required this.description,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: (json['main']['temp'] as num).toDouble(), // Already in Celsius!
      description: json['weather'][0]['description'] ?? 'No description',
      icon: json['weather'][0]['icon'] ?? '01d',
    );
  }
}