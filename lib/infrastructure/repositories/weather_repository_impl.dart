import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

// Implementation of WeatherRepository interface
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource; // Remote data source for weather data

  WeatherRepositoryImpl(this.remoteDataSource); // Constructor to initialize with remote data source

  // Fetch weather data for a specific location
  @override
  Future<Weather> getWeather(String location) async {
    return await remoteDataSource.getWeather(location);
  }

  // Fetch weather data for the current device location
  @override
  Future<Weather> getCurrentLocationWeather() async {
    return await remoteDataSource.getCurrentLocationWeather();
  }
}
