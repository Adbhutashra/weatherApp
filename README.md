# Weather App

The Weather App is a Flutter application that allows users to check weather information based on location. It integrates with Firebase authentication for user login and utilizes external APIs for fetching weather data.

# Features

- User authentication (Sign Up, Login, Logout)
- Weather information display for current location and specified locations
- Integration with OpenWeatherMap API for weather data
- Persistence of weather data using Hive database
- Responsive UI with Flutter Material Design components

# Screenshots

![Alt text](../weatherapp/assets/screenshots/login.jpg "Login")
![Alt text](../weatherapp/assets/screenshots/signup.jpg "Signup")
![Alt text](../weatherapp/assets/screenshots/locationpermission.jpg "Permission")
![Alt text](../weatherapp/assets/screenshots/homepage1.jpg "Homepage")
![Alt text](../weatherapp/assets/screenshots/homepage.jpg "Weather Info")
![Alt text](../weatherapp/assets/screenshots/selectlocation.jpg "Select Location")

# Getting Started

To get started with this application, follow these steps:

# Prerequisites

Flutter SDK installed on your machine. Install Flutter
Firebase project set up for authentication. Set up Firebase
Installation

# Clone the repository:

git clone https://github.com/Adbhutashra/weatherApp.git
cd weather_app

# Install dependencies:

flutter pub get

# Configure Firebase:

Add your Firebase configuration file (google-services.json for Android, GoogleService-Info.plist for iOS) to the android/app and ios/Runner directories respectively.

# Run the app:

flutter run

# Usage

Login: Enter your email and password to log in.
Sign Up: Create a new account by providing your email and password.
Weather Display: View weather information for your current location or enter a location to fetch weather details.
Logout: Log out from the app, and you won't be able to navigate back to authenticated screens.
Technologies Used
Flutter & Dart
Firebase Authentication
Dio for HTTP requests
Hive for local data storage
Bloc pattern for state management

# Folder Structure

weather_app/
├── android/
├── ios/
├── lib/
│ ├── application/
│ │ ├── blocs/
│ │ │ ├── auth_bloc.dart
│ │ │ ├── weather_bloc.dart
│ │ ├── usecases/
│ │ │ ├── get_weather.dart
│ ├── domain/
│ │ ├── entities/
│ │ │ ├── weather.dart
│ │ ├── repositories/
│ │ │ ├── weather_repository.dart
│ ├── infrastructure/
│ │ ├── datasources/
│ │ │ ├── weather_remote_data_source.dart
│ │ ├── repositories/
│ │ │ ├── weather_repository_impl.dart
│ ├── presentation/
│ │ ├── pages/
│ │ │ ├── home_page.dart
│ │ │ ├── login_page.dart
│ │ │ ├── signup_page.dart
│ │ │ ├── location_selection_page.dart
│ │ ├── routes/
│ │ │ ├── routes.dart
│ ├── main.dart
├── pubspec.yaml

# Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
