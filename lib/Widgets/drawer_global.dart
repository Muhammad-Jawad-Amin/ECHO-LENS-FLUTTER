import 'package:flutter/material.dart';
import 'package:echo_lens/Screens/Main/aboutus_screen.dart';
import 'package:echo_lens/Screens/Main/history_screen.dart';
import 'package:echo_lens/Screens/Main/home_screen.dart';
import 'package:echo_lens/Screens/Startup/login_screen.dart';
import 'package:echo_lens/Screens/Main/profile_screen.dart';
import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:echo_lens/Services/auth_service.dart';

class DrawerGlobal extends StatelessWidget {
  const DrawerGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: GlobalColors.themeColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset('assets/logo.png')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 10, top: 25),
                child: ListTile(
                  title: Text(
                    "H O M E",
                    style: TextStyle(
                      color: GlobalColors.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.home,
                    color: GlobalColors.mainColor,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 10),
                child: ListTile(
                  title: Text(
                    "P R O F I L E",
                    style: TextStyle(
                      color: GlobalColors.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.person,
                    color: GlobalColors.mainColor,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 10),
                child: ListTile(
                  title: Text(
                    "H I S T O R Y",
                    style: TextStyle(
                      color: GlobalColors.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.history,
                    color: GlobalColors.mainColor,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 10),
                child: ListTile(
                  title: Text(
                    "A B O U T   U S",
                    style: TextStyle(
                      color: GlobalColors.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.info,
                    color: GlobalColors.mainColor,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 25),
            child: ListTile(
              title: Text(
                "L O G O  O U T",
                style: TextStyle(
                  color: GlobalColors.mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(
                Icons.logout,
                color: GlobalColors.mainColor,
              ),
              onTap: () {
                logout(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) {
    AuthService auth = AuthService();
    auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
