import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/presentation/utilities.dart';
import '../../application/blocs/auth_bloc.dart';
import '../routes/routes.dart';

// LoginPage allows user to login with email and password
class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key}); // Constructor with optional key parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), automaticallyImplyLeading: false,), // Title of the app bar
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.home,
                (route) =>
                    false, // Removes all routes from the stack until the new route
              );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state
                      .message)), // Show error message in a SnackBar on authentication error
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Email'), // Label for email input field
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText: 'Password'), // Label for password input field
                obscureText: true, // Hide password text
              ),
              const SizedBox(
                  height:
                      16.0), // Spacer between password field and login button
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isEmpty ||
                      !isValidEmail(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please enter a valid email')), // Show error message if email is empty or invalid
                    );
                    return;
                  }

                  if (passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please enter password')), // Show error message if password is empty
                    );
                    return;
                  }
                  final email = emailController.text;
                  final password = passwordController.text;
                  context.read<AuthBloc>().add(SignIn(email,
                      password)); // Dispatch SignIn event to AuthBloc on login button press
                },
                child: const Text('Login'), // Text displayed on the login button
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        "Don't have an account?"), // Prompt to create a new account
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context,
                            Routes
                                .signup); // Navigate to signup page on sign up button press
                      },
                      child: const Text(
                          'Sign Up'), // Text displayed on the sign up button
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
