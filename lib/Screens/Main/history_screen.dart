import 'dart:async';
import 'package:echo_lens/Screens/Main/caption_screen.dart';
import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:echo_lens/Widgets/drawer_global.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_lens/Services/firestore_service.dart';

class HistoryScreen extends StatefulWidget {
  final FirestoreService _firestoreService = FirestoreService();

  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Display the progress indicator for 3 seconds
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
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
          'H I S T O R Y',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontSize: 20,
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: GlobalColors.mainColor,
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: widget._firestoreService.getCaptions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No history found.',
                      style: TextStyle(
                        color: GlobalColors.mainColor,
                        fontSize: 20,
                      ),
                    ),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(15),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var historyItem = snapshot.data!.docs[index];
                      String documentId = historyItem.id; // Get the document ID

                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
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
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: GlobalColors.mainColor
                                        .withOpacity(0.25),
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
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 231, 21, 6),
                              ),
                              onPressed: () {
                                _showDeleteDialog(context, documentId);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: GlobalColors.themeColor,
          title: Text(
            'Delete Image',
            style: TextStyle(
              color: GlobalColors.mainColor,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this image?',
            style: TextStyle(
              color: GlobalColors.mainColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: GlobalColors.mainColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await widget._firestoreService.deleteCaption(documentId);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: GlobalColors.mainColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
