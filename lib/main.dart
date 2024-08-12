import 'package:flutter/material.dart';
import 'package:echo_lens/Screens/splash_screen.dart';
import 'package:echo_lens/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return const MaterialApp(
      title: 'ECHO LENS',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
