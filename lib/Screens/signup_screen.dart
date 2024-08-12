import 'package:echo_lens/Screens/home_screen.dart';
import 'package:echo_lens/Services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:echo_lens/Screens/profilesetup_screen.dart';
import 'package:echo_lens/Screens/login_screen.dart';
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

  Future<void> signup(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    String confpassword = confpasswordController.text;

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password must be 8 or more charaters long.'),
          backgroundColor: GlobalColors.textColor,
        ),
      );
    } else if (password != confpassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password & Confirm-Password must be same.'),
          backgroundColor: GlobalColors.textColor,
        ),
      );
    } else {
      try {
        User? user = await authService.signUp(
          email,
          password,
        );

        if (user != null) {
          if (!context.mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserProfileSetup(email: email),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // Show error message that email is already in use
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Could not SignUp. Account already exists with this emal.'),
              backgroundColor: GlobalColors.themeColor,
            ),
          );
        } else {
          // Handle other errors
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('An error occured, please try again later.'),
              backgroundColor: GlobalColors.themeColor,
            ),
          );
        }
        // Handle error
      }
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      User? user = await authService.loginWithGoogle();
      if (user != null) {
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
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('An error occured. Could not sign in with Google.'),
          backgroundColor: GlobalColors.themeColor,
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
                  'Create your Account',
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
                  obscure: false,
                ),

                const SizedBox(
                  height: 15,
                ),
                // password field
                TextFormGlobal(
                  controller: passwordController,
                  text: 'Password',
                  textInputType: TextInputType.visiblePassword,
                  obscure: true,
                ),

                const SizedBox(
                  height: 15,
                ),
                // password field
                TextFormGlobal(
                  controller: confpasswordController,
                  text: 'Confirm Password',
                  textInputType: TextInputType.visiblePassword,
                  obscure: true,
                ),

                const SizedBox(
                  height: 35,
                ),
                ButtonGlobal(
                  buttontext: 'Sign Up',
                  onPressed: () {
                    signup(context);
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                //Social Sign Up
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
              'Already have an account? ',
              style: TextStyle(color: GlobalColors.textColor),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: InkWell(
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: GlobalColors.textColor,
                      fontWeight: FontWeight.w900),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
