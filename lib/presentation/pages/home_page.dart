import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/blocs/auth_bloc.dart';
import '../../application/blocs/weather_bloc.dart';
import '../routes/routes.dart';

// HomePage widget displays weather information and allows interaction with weather data
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'), // Title of the app bar
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Logout button icon
            onPressed: () {
              context
                  .read<AuthBloc>()
                  .add(SignOut()); // Dispatches a SignOut event to AuthBloc
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.login,
                (route) =>
                    false, // Removes all routes from the stack until the new route
              );
               // Navigates to login page
            },
          ),
        ],
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherInitial) {
            return const Center(
                child: Text('Tap on location icon')); // Initial state message
          } else if (state is WeatherLoading) {
            return const Center(
                child: CircularProgressIndicator()); // Loading state indicator
          } else if (state is WeatherLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Temperature: ${state.weather.temperature}°C'), // Display temperature
                  Text(
                      'Humidity: ${state.weather.humidity}%'), // Display humidity
                  Text(
                      'Wind Speed: ${state.weather.windSpeed} m/s'), // Display wind speed
                  Text(
                      'Description: ${state.weather.description}'), // Display weather description
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context,
                          Routes
                              .locationSelection); // Navigate to location selection page
                    },
                    child: Text(
                        'Enter a location'), // Button to enter a custom location
                  ),
                ],
              ),
            );
          } else if (state is WeatherError) {
            return const Center(
                child: Text('Failed to fetch weather')); // Error state message
          } else {
            return Container(); // Default empty container
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<WeatherBloc>().add(
              GetWeatherForCurrentLocation()); // Trigger fetching weather for current location
        },
        child: Icon(Icons
            .my_location), // Icon for fetching weather for current location
      ),
    );
  }
}
