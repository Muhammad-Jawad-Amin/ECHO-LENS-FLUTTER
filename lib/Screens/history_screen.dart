import 'package:echo_lens/Screens/caption_screen.dart';
import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:echo_lens/Widgets/drawer_global.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_lens/Services/firestore_service.dart';

class HistoryScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.themeColor,
      drawer: const DrawerGlobal(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GlobalColors.themeColor,
        title: Text(
          'H I S T O R Y',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontSize: 20,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getCaptions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No history found'),
            );
          }
          return Container(
            padding: const EdgeInsets.all(15),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var historyItem = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaptionScreen(
                          image: Image.network(
                            historyItem['image_url'],
                            fit: BoxFit.cover,
                          ),
                          caption: historyItem['caption'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: GlobalColors.mainColor,
                        width: 5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: GlobalColors.mainColor.withOpacity(0.25),
                          blurRadius: 10,
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(
                          historyItem['image_url'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
