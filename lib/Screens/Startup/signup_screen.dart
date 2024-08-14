import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:echo_lens/Screens/Main/home_screen.dart';
import 'package:echo_lens/Services/firestore_service.dart';
import 'package:echo_lens/Services/validatiors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:echo_lens/Screens/Startup/profilesetup_screen.dart';
import 'package:echo_lens/Screens/Startup/verifyemail_screen.dart';
import 'package:echo_lens/Screens/Startup/login_screen.dart';
import 'package:echo_lens/Widgets/textform_global.dart';
import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:echo_lens/Widgets/button_global.dart';
import 'package:echo_lens/Services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthService authService = AuthService();
  FirestoreService firestoreService = FirestoreService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confpasswordController = TextEditingController();

  void showerrormessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: GlobalColors.themeColor,
          ),
        ),
        backgroundColor: GlobalColors.mainColor,
      ),
    );
  }

  Future<void> signup(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confpassword = confpasswordController.text.trim();

    if (!Validators.isValidEmail(email)) {
      showerrormessage(context, 'Please enter a valid Email.');
    } else if (!Validators.isValidPassword(password)) {
      showerrormessage(context,
          'Enter 8-Charater Password contaning at least: 1 Capital, 1 Small Letter & 1 Special Character.');
    } else if (password != confpassword) {
      showerrormessage(context, 'Password & Confirm-Password must be same.');
    } else {
      try {
        User? user = await authService.signUp(
          email,
          password,
        );

        if (user != null) {
          if (!context.mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => VerifyEmailScreen(email: email),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // Show error message that email is already in use
          if (!context.mounted) return;
          showerrormessage(context,
              'Could not SignUp. Account already exists with this emal.');
        } else {
          // Handle other errors
          if (!context.mounted) return;
          showerrormessage(
              context, 'An error occured, please try again later.');
        }
      } catch (e) {
        if (!context.mounted) return;
        showerrormessage(context, 'An error occured, please try again later.');
      }
    }
  }

  Future<void> _signUpWithGoogle(BuildContext context) async {
    try {
      User? user = await authService.loginWithGoogle();

      if (user != null) {
        if (await firestoreService.isEmailAlreadyUsed(user.email!)) {
          if (!context.mounted) return;
          showerrormessage(
              context, "An account has already exists on this email.");
          return;
        }
        bool isuserexist = await firestoreService.isUserDataExists(user.uid);
        if (isuserexist) {
          if (!context.mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          // Handle successful sign-in
          if (!context.mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserProfileSetup(email: user.email!),
            ),
          );
        }
      } else {
        if (!context.mounted) return;
        showerrormessage(
          context,
          'Could not SignUp with Google. Please try again later.',
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('An error occured. Could not SignUp with Google.'),
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
                  'Create your Account:',
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),

                // email filed
                TextFormGlobal(
                  controller: emailController,
                  text: 'Email',
                  textInputType: TextInputType.emailAddress,
                ),

                const SizedBox(
                  height: 15,
                ),
                // password field
                TextFormGlobal(
                  controller: passwordController,
                  text: 'Password',
                  textInputType: TextInputType.visiblePassword,
                  password: true,
                ),

                const SizedBox(
                  height: 15,
                ),
                // password field
                TextFormGlobal(
                  controller: confpasswordController,
                  text: 'Confirm Password',
                  textInputType: TextInputType.visiblePassword,
                  password: true,
                ),

                const SizedBox(
                  height: 35,
                ),
                ButtonGlobal(
                  buttontext: 'SIGN UP',
                  onPressed: () {
                    signup(context);
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                //Social Sign Up
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '- OR -',
                        style: TextStyle(
                          color: GlobalColors.textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            await _signUpWithGoogle(context);
                          },
                          child: Container(
                            height: 55,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: GlobalColors.themeColor,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: GlobalColors.mainColor,
                                width: 3,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/google.svg',
                                  height: 30,
                                ),
                                Text(
                                  "     Sign Up With Google",
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
              'Already have an account? ',
              style: TextStyle(color: GlobalColors.textColor),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: InkWell(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: GlobalColors.mainColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
