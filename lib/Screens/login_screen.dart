import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:echo_lens/Screens/home_screen.dart';
import 'package:echo_lens/Screens/profilesetup_screen.dart';
import 'package:echo_lens/Screens/signup_screen.dart';
import 'package:echo_lens/Services/firestore_service.dart';
import 'package:echo_lens/Services/validatiors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:echo_lens/Widgets/button_global.dart';
import 'package:echo_lens/Widgets/textform_global.dart';
import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:echo_lens/Services/auth_service.dart';

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

  void showerrormessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: GlobalColors.themeColor,
          ),
        ),
        backgroundColor: GlobalColors.mainColor,
      ),
    );
  }

  void changescreen(BuildContext context, bool userexist, String email) {
    if (userexist) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserProfileSetup(email: email),
        ),
      );
    }
  }

  Future<void> signIn(BuildContext context) async {
    if (!Validators.isValidEmail(email.text)) {
      showerrormessage(context, 'Please enter a valid Email.');
    } else if (!Validators.isValidPassword(password.text)) {
      showerrormessage(context,
          'Enter 8-Charater Password contaning at least: 1 Capital, 1 Small Letter & 1 Special Character.');
    } else {
      try {
        User? user = await authService.login(email.text, password.text);
        if (user != null) {
          bool isuserexist = await firestoreService.isUserDataExists(user.uid);
          if (!context.mounted) return;
          changescreen(context, isuserexist, user.email!);
        } else {
          if (!context.mounted) return;
          showerrormessage(
            context,
            'Could not LogIn. Check your Email & Password then Try Again.',
          );
        }
      } on FirebaseAuthException {
        showerrormessage(context,
            'Could not LogIn. Check your Email & Password then Try Again.');
      } catch (e) {
        showerrormessage(
            context, 'Could not LogIn to your account. Try again later.');
      }
    }
  }

  Future<void> _logInWithGoogle(BuildContext context) async {
    try {
      User? user = await authService.loginWithGoogle();

      if (user != null) {
        bool isuserexist = await firestoreService.isUserDataExists(user.uid);
        if (!context.mounted) return;
        changescreen(context, isuserexist, user.email!);
      } else {
        if (!context.mounted) return;
        showerrormessage(
          context,
          'Could not LogIn with Google. Please try again later.',
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An error occured. Could not LogIn with Google.'),
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
                ),
                const SizedBox(
                  height: 15,
                ),
                // password field
                TextFormGlobal(
                  controller: password,
                  text: 'Password',
                  textInputType: TextInputType.visiblePassword,
                  password: true,
                ),
                const SizedBox(
                  height: 35,
                ),
                ButtonGlobal(
                  buttontext: 'LOG IN',
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
                            await _logInWithGoogle(context);
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
                                  "     LOG IN WITH GOOGLE",
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
                  'SignUp',
                  style: TextStyle(
                    color: GlobalColors.mainColor,
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
