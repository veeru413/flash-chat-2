import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat_app2/screens/welcome_screen.dart';
import 'package:flash_chat_app2/screens/login_screen.dart';
import 'package:flash_chat_app2/screens/registration_screen.dart';
import 'package:flash_chat_app2/screens/chat_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FlashChat());
}
// void main(){
//   runApp(const FlashChat());
// }

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black54),
        ),
      ),
      home: const InitializationScreen(), // The new initialization screen
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
      },
    );
  }
}

class InitializationScreen extends StatefulWidget {
  const InitializationScreen({super.key});

  @override
  _InitializationScreenState createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  void _initializeFirebase() async {
    try {
      print("Initializing Firebase...");
      await Firebase.initializeApp();
      print("Firebase initialized successfully.");
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print("Firebase initialization error: $e");
      setState(() {
        _error = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_error) {
      return const Scaffold(
        body: Center(child: Text('Failed to initialize Firebase')),
      );
    }
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // Loading indicator while Firebase initializes
      );
    }

    // Once Firebase is initialized, navigate to the WelcomeScreen
    return const WelcomeScreen();
  }
}
