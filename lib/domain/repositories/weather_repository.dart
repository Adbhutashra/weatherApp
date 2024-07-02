import 'package:weatherapp/domain/entities/weather.dart';

// Abstract class defining the contract for Weather repositories
abstract class WeatherRepository {
  
  // Fetch weather for a specific location
  Future<Weather> getWeather(String location);

  // Fetch weather for the current device location
  Future<Weather> getCurrentLocationWeather();
}
