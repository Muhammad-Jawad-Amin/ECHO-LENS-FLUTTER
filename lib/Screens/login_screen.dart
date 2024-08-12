import 'package:echo_lens/Screens/home_screen.dart';
import 'package:echo_lens/Screens/profilesetup_screen.dart';
import 'package:echo_lens/Screens/signup_screen.dart';
import 'package:echo_lens/Services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:echo_lens/Widgets/button_global.dart';
import 'package:echo_lens/Widgets/textform_global.dart';
import 'package:echo_lens/Widgets/colors_global.dart';
import '../Services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService authService = AuthService();
  FirestoreService firestoreService = FirestoreService();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> signIn(context) async {
    try {
      User? user = await authService.login(email.text, password.text);

      if (user != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Could not LogIn. Check your Email & Password then Try Again.'),
          backgroundColor: GlobalColors.textColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Could not LogIn to your account. Try again later.'),
          backgroundColor: GlobalColors.textColor,
        ),
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      User? user = await authService.loginWithGoogle();
      if (user != null) {
        bool isuserexist = await firestoreService.isUserDataExists(user.uid);
        if (isuserexist) {
           if(!context.mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          // Handle successful sign-in
          if(!context.mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserProfileSetup(email: user.email!),
            ),
          );
        }
      }
    } catch (e) {
       if(!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('An error occured. Could not sign in with Google.'),
          backgroundColor: GlobalColors.textColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.themeColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: SizedBox(
                      height: 250,
                      width: 250,
                      child: Image.asset('assets/logo.png')),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Login to your Account',
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                // email field
                TextFormGlobal(
                  controller: email,
                  text: 'Email',
                  textInputType: TextInputType.emailAddress,
                  obscure: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                // password field
                TextFormGlobal(
                  controller: password,
                  text: 'Password',
                  textInputType: TextInputType.visiblePassword,
                  obscure: true,
                ),
                const SizedBox(
                  height: 35,
                ),
                ButtonGlobal(
                  buttontext: 'Sign In',
                  onPressed: () {
                    signIn(context);
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                // Social Buttons
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '-OR-',
                        style: TextStyle(
                          color: GlobalColors.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            await _signInWithGoogle(context);
                          },
                          child: Container(
                            height: 55,
                            width: 300,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: GlobalColors.themeColor,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: GlobalColors.mainColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/google.svg',
                                  height: 30,
                                ),
                                Text(
                                  "     Sign In with Google",
                                  style: TextStyle(
                                    color: GlobalColors.textColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: GlobalColors.themeColor,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account? ',
              style: TextStyle(color: GlobalColors.textColor),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignupScreen(),
                  ),
                );
              },
              child: InkWell(
                child: Text(
                  'Signup',
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
