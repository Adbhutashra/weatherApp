import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/domain/entities/weather_model.dart';
import 'application/blocs/weather_bloc.dart';
import 'application/blocs/auth_bloc.dart';
import 'domain/repositories/weather_repository.dart';
import 'domain/usecases/get_weather.dart';
import 'infrastructure/datasources/weather_remote_data_source.dart';
import 'infrastructure/repositories/weather_repository_impl.dart';
import 'presentation/routes/routes.dart';

// GetIt service locator instance
final sl = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyAUuuAu7p2_OdYZZRsI3y7_ytKY5htMxes',
    appId: 'id',
    messagingSenderId: 'sendid',
    projectId: 'weather-app-1c588',
    storageBucket: 'weather-app-1c588.appspot.com',
  ));

  // Initialize Hive for local storage
  await Hive.initFlutter();
  Hive.registerAdapter(
      WeatherAdapter()); // Register Hive adapter for Weather model
  await Hive.openBox(
      'weatherBox'); // Open Hive box for storing weather data locally

  // Initialize SharedPreferences for simple local data storage
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Register dependencies with GetIt service locator
  sl.registerLazySingleton(() => Dio()); // Register Dio HTTP client instance
  sl.registerLazySingleton(() => WeatherRemoteDataSource(
      sl())); // Register WeatherRemoteDataSource instance
  sl.registerLazySingleton<WeatherRepository>(() =>
      WeatherRepositoryImpl(sl())); // Register WeatherRepository implementation
  sl.registerLazySingleton(
      () => GetWeather(sl())); // Register GetWeather use case
  sl.registerFactory(() => WeatherBloc(sl())); // Register WeatherBloc
  sl.registerFactory(() =>
      AuthBloc(prefs)); // Register AuthBloc with SharedPreferences dependency

  // Run the app
  runApp(MyApp());
}

// MyApp is the root widget for the Flutter application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                sl<WeatherBloc>()), // Provide WeatherBloc to the widget tree
        BlocProvider(
            create: (_) =>
                sl<AuthBloc>()), // Provide AuthBloc to the widget tree
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false, // Disable debug banner
        title: 'Weather App', // App title
        initialRoute: Routes.login, // Initial route on app startup
        onGenerateRoute:
            Routes.generateRoute, // Route generator for named routes
      ),
    );
  }
}
