import 'package:flutter/material.dart';
import 'package:echo_lens/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:echo_lens/Screens/home_screen.dart';
import 'package:echo_lens/Screens/login_screen.dart';
import 'package:echo_lens/Services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Caption Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthService().currentUser != null
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
