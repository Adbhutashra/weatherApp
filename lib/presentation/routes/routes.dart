import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/signup_page.dart';
import '../pages/location_selection_page.dart';

// Routes class manages named routes and route generation for the app
class Routes {
  static const String home = '/'; // Route name for home page
  static const String login = '/login'; // Route name for login page
  static const String signup = '/signup'; // Route name for signup page
  static const String locationSelection = '/location_selection'; // Route name for location selection page

  // generateRoute method generates the appropriate route based on settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage()); // Navigate to HomePage for '/'
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage()); // Navigate to LoginPage for '/login'
      case signup:
        return MaterialPageRoute(builder: (_) => SignupPage()); // Navigate to SignupPage for '/signup'
      case locationSelection:
        return MaterialPageRoute(builder: (_) => LocationSelectionPage()); // Navigate to LocationSelectionPage for '/location_selection'
      default:
        return MaterialPageRoute(builder: (_) => HomePage()); // Default to HomePage if route not found
    }
  }
}
