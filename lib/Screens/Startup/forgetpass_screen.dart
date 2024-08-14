import 'package:echo_lens/Services/auth_service.dart';
import 'package:echo_lens/Services/firestore_service.dart';
import 'package:echo_lens/Services/validatiors.dart';
import 'package:flutter/material.dart';
import 'package:echo_lens/Screens/Startup/login_screen.dart';
import 'package:echo_lens/Widgets/textform_global.dart';
import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:echo_lens/Widgets/button_global.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  AuthService authService = AuthService();
  FirestoreService firestoreService = FirestoreService();
  TextEditingController emailcontroller = TextEditingController();

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

  Future<void> resetPassword() async {
    String email = emailcontroller.text.trim();
    if (!Validators.isValidEmail(email)) {
      showerrormessage('Please enter a valid Email.');
    } else {
      if (await firestoreService.isEmailAlreadyUsed(email)) {
        String message = await authService.passwordRest(email);
        showerrormessage(message);
      } else {
        showerrormessage("User not found.");
      }
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
                  height: 100,
                ),
                Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Reset your Password:',
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
                  controller: emailcontroller,
                  text: 'Email',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 35,
                ),
                ButtonGlobal(
                  buttontext: 'Reset Password',
                  onPressed: resetPassword,
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
              'If successfully reseted your password? ',
              style: TextStyle(color: GlobalColors.textColor),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
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
