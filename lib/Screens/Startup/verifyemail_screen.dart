import 'package:echo_lens/Screens/Startup/signup_screen.dart';
import 'package:echo_lens/Widgets/button_global.dart';
import 'package:flutter/material.dart';
import 'package:echo_lens/Services/auth_service.dart';
import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:echo_lens/Screens/Startup/profilesetup_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final AuthService _authService = AuthService();
  String message = "";

  @override
  void initState() {
    super.initState();
    _authService.startEmailVerificationCheck(onEmailVerified, widget.email);
    message = 'An Email verification link has been sent to your Email.';
  }

  @override
  void dispose() {
    _authService.stopEmailVerificationCheck();
    super.dispose();
  }

  void showerrormessage(String message) {
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

  void onEmailVerified() {
    showerrormessage("Email verified successfully.");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => UserProfileSetup(email: widget.email),
      ),
    );
  }

  void onSignupAgain() {
    _authService.deleteUserIfNotVerified();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  void resendverifyemail() {
    _authService.startEmailVerificationCheck(onEmailVerified, widget.email);
    message = "An Email verification link has been resent to your Email.";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.themeColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  'assets/logo.png',
                  height: 250,
                  width: 250,
                ),
                const SizedBox(height: 50),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: GlobalColors.textColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    "At :  ${widget.email}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: GlobalColors.mainColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                ButtonGlobal(
                  buttontext: "Resend Verification Email",
                  onPressed: resendverifyemail,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '- OR -',
                    style: TextStyle(
                      color: GlobalColors.textColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ButtonGlobal(
                  buttontext: "Sign Up Agian",
                  onPressed: onSignupAgain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
