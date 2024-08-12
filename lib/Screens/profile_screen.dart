import 'package:echo_lens/Models/user_model.dart';
import 'package:echo_lens/Services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:echo_lens/Widgets/drawer_global.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel userobj = UserModel(
    email: "",
    fname: "",
    lname: "",
    address: "",
    dateofbirth: "",
  );
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();

    firestoreService.getuserData().then((fetchedUserData) {
      userobj = fetchedUserData;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.themeColor,
      drawer: const DrawerGlobal(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GlobalColors.themeColor,
        title: Text(
          'P R O F I L E',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color:
                  GlobalColors.mainColor, // Custom color for the hamburger icon
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: Image.asset('assets/logo.png'),
              ),
            ),
            const SizedBox(height: 30),
            _buildInfoRow('First Name', userobj.fname),
            const SizedBox(height: 15),
            _buildInfoRow('Last Name', userobj.lname),
            const SizedBox(height: 15),
            _buildInfoRow('Email', userobj.email),
            const SizedBox(height: 15),
            _buildInfoRow('Address', userobj.address),
            const SizedBox(height: 15),
            _buildInfoRow('Date of Birth', userobj.dateofbirth),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GlobalColors.textColor),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: GlobalColors.mainColor, fontSize: 18)),
          Text(value,
              style: TextStyle(color: GlobalColors.textColor, fontSize: 18)),
        ],
      ),
    );
  }
}
