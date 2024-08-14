import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:flutter/material.dart';
import 'package:echo_lens/Screens/Main/home_screen.dart';
import 'package:echo_lens/Screens/Startup/login_screen.dart';
import 'package:echo_lens/Screens/Startup/profilesetup_screen.dart';
import 'package:echo_lens/Services/auth_service.dart';
import 'package:echo_lens/services/firestore_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    AuthService authService = AuthService();
    FirestoreService firestoreService = FirestoreService();

    Widget nextPage;
    if (authService.getcurrentUser() != null &&
        await firestoreService.isUserDataExists(authService.getuserId())) {
      nextPage = const HomeScreen();
    } else if (authService.getcurrentUser() != null) {
      nextPage = UserProfileSetup(email: authService.getuserEmail());
    } else {
      nextPage = const LoginScreen();
    }

    // Simulate some delay or perform initialization
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.themeColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset('assets/logo.png'),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(GlobalColors.mainColor),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 50),
        color: GlobalColors.themeColor,
        child: Image.asset('assets/branding.png'),
      ),
    );
  }
}
