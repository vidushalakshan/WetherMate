class Weather {
  final String city;
  final double temp;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.city,
    required this.temp,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'] ?? 'Unknown',
      temp: (json['main']['temp'] as num).toDouble(), // Already in Celsius now!
      description: json['weather'][0]['description'] ?? 'No description',
      icon: json['weather'][0]['icon'] ?? '01d',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num?)?.toDouble() ?? 0.0,
    );
  }
}