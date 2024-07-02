import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define abstract class for Authentication Events
abstract class AuthEvent {}

// Define SignIn event with email and password parameters
class SignIn extends AuthEvent {
  final String email;
  final String password;

  SignIn(this.email, this.password);
}

// Define SignUp event with email and password parameters
class SignUp extends AuthEvent {
  final String email;
  final String password;

  SignUp(this.email, this.password);
}

// Define SignOut event
class SignOut extends AuthEvent {}

// Define abstract class for Authentication States
abstract class AuthState {}

// Define initial state of Authentication
class AuthInitial extends AuthState {}

// Define authenticated state with a User object
class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

// Define unauthenticated state
class Unauthenticated extends AuthState {}

// Define authentication error state with an error message
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

// Define Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase authentication instance
  final SharedPreferences _prefs; // Shared preferences instance for local storage

  // Constructor initializes with initial state and event handlers
  AuthBloc(this._prefs) : super(AuthInitial()) {
    on<SignIn>(_onSignIn);
    on<SignUp>(_onSignUp);
    on<SignOut>(_onSignOut);

    _checkAuthStatus(); // Check authentication status on initialization
  }

  // Check authentication status from local storage
  Future<void> _checkAuthStatus() async {
    final String? userEmail = _prefs.getString('userEmail');
    if (userEmail != null) {
      final User? user = _auth.currentUser;
      if (user != null) {
        add(SignIn(userEmail, '')); // Trigger sign-in event if user is found
      } else {
        add(SignOut()); // Trigger sign-out event if no user is found
      }
    } else {
      emit(Unauthenticated()); // Emit unauthenticated state if no user email is found
    }
  }

  // Save user state to local storage
  Future<void> _saveUserState(User user) async {
    await _prefs.setString('userEmail', user.email ?? '');
  }

  // Clear user state from local storage
  Future<void> _clearUserState() async {
    await _prefs.remove('userEmail');
  }

  // Handle SignIn event
  void _onSignIn(SignIn event, Emitter<AuthState> emit) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await _saveUserState(userCredential.user!);
      emit(Authenticated(userCredential.user!)); // Emit authenticated state on successful sign-in
    } catch (e) {
      emit(AuthError(e.toString())); // Emit error state on sign-in failure
    }
  }

  // Handle SignUp event
  void _onSignUp(SignUp event, Emitter<AuthState> emit) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await _saveUserState(userCredential.user!);
      emit(Authenticated(userCredential.user!)); // Emit authenticated state on successful sign-up
    } catch (e) {
      emit(AuthError(e.toString())); // Emit error state on sign-up failure
    }
  }

  // Handle SignOut event
  void _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    await _clearUserState();
    emit(Unauthenticated()); // Emit unauthenticated state on successful sign-out
  }
}
