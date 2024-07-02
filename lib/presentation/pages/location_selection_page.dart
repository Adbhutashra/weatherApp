import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/blocs/weather_bloc.dart';

// LocationSelectionPage allows user to enter a custom location and fetch weather data
class LocationSelectionPage extends StatelessWidget {
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Select Location')), // Title of the app bar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                  labelText:
                      'Indore,Madhya Pradesh,IN', // Placeholder text for TextField
                  labelStyle: TextStyle(
                      color: Colors.grey)), // Styling for placeholder text
            ),
            const SizedBox(
                height: 16.0), // Spacer between TextField and ElevatedButton
            ElevatedButton(
              onPressed: () {
                final location =
                    locationController.text; // Get text from TextField
                context.read<WeatherBloc>().add(GetWeatherForLocation(
                    location)); // Dispatch event to WeatherBloc to fetch weather for entered location
                Navigator.pop(context); // Close the location selection page
              },
              child: const Text(
                  'Fetch Weather'), // Text displayed on the ElevatedButton
            ),
          ],
        ),
      ),
    );
  }
}
