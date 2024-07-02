import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

// Class responsible for getting weather data
class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  // Method to get weather for a specific location
  Future<Weather> call(String location) async {
    return await repository.getWeather(location);
  }

  // Method to get weather for the current device location
  Future<Weather> getCurrentLocationWeather() async {
    return await repository.getCurrentLocationWeather();
  }
}
