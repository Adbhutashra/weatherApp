import 'package:hive/hive.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class Weather extends HiveObject {
  @HiveField(0)
  double temperature;

  @HiveField(1)
  int humidity;

  @HiveField(2)
  double windSpeed;

  @HiveField(3)
  String description;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.description,
  });
}
