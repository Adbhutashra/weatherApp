import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';
import 'package:weatherapp/domain/entities/weather.dart';
import 'package:location/location.dart' as loc;

// Remote data source responsible for fetching weather data from APIs and managing location services
class WeatherRemoteDataSource {
  final Dio dio; // Dio instance for making HTTP requests
  final Box weatherBox = Hive.box('weatherBox'); // Hive box for local storage

  WeatherRemoteDataSource(this.dio);

  // Fetch weather data for a specific location from OpenWeatherMap API
  Future<Weather> getWeather(String location) async {
    try {
      final response = await dio.get(
          'https://api.openweathermap.org/data/2.5/weather?q=$location&APPID=03ef70d9a85205d3b5c2fdd5d753c227&units=metric');

      final data = response.data;
      Weather weather = Weather(
        temperature: data['main']['temp'],
        humidity: data['main']['humidity'],
        windSpeed: data['wind']['speed'],
        description: data['weather'][0]['description'],
      );
      saveWeather(weather); // Save weather data to local storage
      return weather;
    } catch (e) {
      // If fetching from API fails, fallback to last cached weather data if available
      if (weatherBox.containsKey('lastWeather')) {
        return weatherBox.get('lastWeather') as Weather;
      } else {
        throw Exception(
            'Failed to fetch weather data and no local data available.');
      }
    }
  }

  // Save weather data to local storage
  void saveWeather(Weather weather) {
    weatherBox.put('lastWeather', weather);
  }

  // Fetch weather data for the current device location
  Future<Weather> getCurrentLocationWeather() async {
    await getCurrentLocation(); // Get current device location
    Position position = await _determinePosition(); // Determine geolocation coordinates
    String location =
        await _getAddressFromLatLng(position.latitude, position.longitude); // Get location name from coordinates
    return getWeather(location); // Fetch weather data for the determined location
  }

  // Get current device location using the location plugin
  Future<loc.LocationData> getCurrentLocation() async {
    loc.Location location = loc.Location();
    final serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      final result = await location.requestService();
      if (result == true) {
        print('Service has been enabled');
      } else {
        throw Exception('GPS service not enabled');
      }
    }
    return await location.getLocation();
  }

  // Determine current device position using Geolocator plugin
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Get address from latitude and longitude using Geocoding plugin
  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark place = placemarks[0];
    return "${place.locality}, ${place.country}";
  }
}
