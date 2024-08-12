import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_lens/Services/auth_service.dart';
import 'package:echo_lens/Services/firestore_service.dart';

class CaptionsHistoryScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  CaptionsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? uid = _authService.currentUser?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Captions History'),
        ),
        body: const Center(
          child: Text('Please log in to view your captions history.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Captions History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getCaptions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No captions found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var imageUrl = doc['image_url'];
              var caption = doc['caption'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(imageUrl, fit: BoxFit.contain),
                      const SizedBox(height: 10),
                      Text(caption, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
