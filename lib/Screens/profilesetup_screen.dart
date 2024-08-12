import 'package:echo_lens/Services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:echo_lens/Screens/home_screen.dart';
import 'package:echo_lens/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:echo_lens/Widgets/button_global.dart';
import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:echo_lens/Widgets/textform_global.dart';

class UserProfileSetup extends StatefulWidget {
  final String email;

  const UserProfileSetup({super.key, required this.email});

  @override
  State<UserProfileSetup> createState() => _UserProfileSetupState();
}

class _UserProfileSetupState extends State<UserProfileSetup> {
  AuthService authService = AuthService();
  FirestoreService firestoreService = FirestoreService();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();

  Future<void> showCalender() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1947),
      lastDate: DateTime(2020),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: GlobalColors.mainColor,
            colorScheme: ColorScheme.dark(primary: GlobalColors.mainColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dateOfBirth.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {});
    }
  }

  Future<void> saveProfile(context) async {
    try {
      User? user = authService.currentUser;
      if (user != null) {
        // Preparing the data to be saved
        Map<String, dynamic> userdata = {
          'email': widget.email,
          'fname': fname.text,
          'lname': lname.text,
          'address': address.text,
          'dateofbirth': dateOfBirth.text,
        };

        firestoreService.saveUserData(userdata);

        // Displaying a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: const Text('Success !!. Profile updated successfully.'),
              backgroundColor: GlobalColors.textColor,
              duration: const Duration(seconds: 2)),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        // Displaying an error message if the user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error !!. No logged in user found.'),
            backgroundColor: GlobalColors.textColor,
          ),
        );
      }
    } catch (e) {
      // Displaying an error message in case of failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error !!. Failed to update profile ${e.toString()}.'),
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
                const SizedBox(height: 18),
                Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  'Setup your Profile',
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                TextFormGlobal(
                  controller: fname,
                  text: 'First Name',
                  textInputType: TextInputType.text,
                  obscure: false,
                ),
                const SizedBox(height: 15),
                TextFormGlobal(
                  controller: lname,
                  text: 'Last Name',
                  textInputType: TextInputType.text,
                  obscure: false,
                ),
                const SizedBox(height: 15),
                TextFormGlobal(
                  controller: address,
                  text: 'Address',
                  textInputType: TextInputType.text,
                  obscure: false,
                ),
                const SizedBox(height: 15),
                TextFormGlobal(
                  controller: dateOfBirth,
                  text: 'Date of Birth',
                  textInputType: TextInputType.datetime,
                  obscure: false,
                  readonly: true,
                  ontap: showCalender,
                ),
                const SizedBox(height: 40),
                ButtonGlobal(
                  buttontext: 'Save Profile',
                  onPressed: () {
                    saveProfile(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
