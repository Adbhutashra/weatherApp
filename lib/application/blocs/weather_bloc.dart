import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/domain/entities/weather.dart';
import 'package:weatherapp/domain/usecases/get_weather.dart';

// Define abstract class for Weather Events
abstract class WeatherEvent {}

// Event to get weather for a specific location
class GetWeatherForLocation extends WeatherEvent {
  final String location;

  GetWeatherForLocation(this.location);
}

// Event to get weather for the current device location
class GetWeatherForCurrentLocation extends WeatherEvent {}

// Define abstract class for Weather States
abstract class WeatherState {}

// Initial state when weather bloc is initialized
class WeatherInitial extends WeatherState {}

// State indicating weather data is being fetched
class WeatherLoading extends WeatherState {}

// State indicating weather data has been successfully loaded
class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded(this.weather);
}

// State indicating an error occurred while fetching weather data
class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}

// Weather BLoC class
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;

  // Constructor initializes with initial state and event handlers
  WeatherBloc(this.getWeather) : super(WeatherInitial()) {
    on<GetWeatherForLocation>(_onGetWeatherForLocation);
    on<GetWeatherForCurrentLocation>(_onGetWeatherForCurrentLocation);
  }

  // Handler for GetWeatherForLocation event
  void _onGetWeatherForLocation(
      GetWeatherForLocation event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading()); // Emit loading state
    try {
      final weather = await getWeather(event.location); // Call use case to get weather
      emit(WeatherLoaded(weather)); // Emit loaded state with weather data
    } catch (e) {
      emit(WeatherError(e.toString())); // Emit error state if there's an exception
    }
  }

  // Handler for GetWeatherForCurrentLocation event
  void _onGetWeatherForCurrentLocation(
      GetWeatherForCurrentLocation event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading()); // Emit loading state
    try {
      final weather = await getWeather.getCurrentLocationWeather(); // Call use case to get current location weather
      emit(WeatherLoaded(weather)); // Emit loaded state with weather data
    } catch (e) {
      emit(WeatherError(e.toString())); // Emit error state if there's an exception
    }
  }
}
