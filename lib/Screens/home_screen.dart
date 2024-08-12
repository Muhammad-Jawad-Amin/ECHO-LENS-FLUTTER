import 'dart:io';
import 'package:echo_lens/Screens/login_screen.dart';
import 'package:echo_lens/Widgets/drawer_global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/firestore_service.dart';
import '../services/api_service.dart';
import 'caption_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _imageFile;
  Uint8List? _imageBytes;
  bool _isLoading = false;

  // Instance of services
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  final FirestoreService _firestoreService = FirestoreService();

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // For web, read the file as bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageFile = null; // Clear file reference on web
        });
      } else {
        // For mobile, use File
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageBytes = null; // Clear bytes reference on mobile
        });
      }
    } else {
      print('No image selected.');
    }
  }

  // Method to generate a caption for the selected image
  Future<void> _generateCaption() async {
    if (_imageFile == null && _imageBytes == null) return;

    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none) && mounted) {
      // No internet connection
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'No internet connection. Please connect to the internet and try again.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show the loading indicator
    });

    String? caption;
    String? imageUrl;

    try {
      // Check if the user is authenticated
      var user = _authService.currentUser;
      if (user == null) {
        throw 'User not logged in';
      }

      // Generate caption
      if (_imageFile != null) {
        caption = await ApiService.generateCaption(_imageFile!);
      } else if (_imageBytes != null) {
        caption = await ApiService.generateCaptionFromBytes(_imageBytes!);
      }

      if (caption != null && mounted) {
        // Upload image to Firebase Storage
        imageUrl = await _storageService.uploadImage(user.uid, _imageFile!);

        // Save caption and image URL to Firestore
        await _firestoreService.saveCaption(imageUrl!, caption);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaptionScreen(
              imageFile: _imageFile,
              imageBytes: _imageBytes,
              caption: caption!,
            ),
          ),
        );
      } else {
        // Handle case where no caption is returned
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Failed to generate caption. Please try again later.'),
            ),
          );
        }
      }
    } catch (e) {
      print('Error generating caption: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // Hide the loading indicator
      });
    }
  }

  // Method to clear the selected image
  void _clearImage() {
    setState(() {
      _imageFile = null;
      _imageBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      drawer: const DrawerGlobal(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300, // Set the width of the image container
              height: 300, // Set the height of the image container
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _imageFile == null && _imageBytes == null
                  ? const Center(child: Text('No image selected.'))
                  : kIsWeb
                      ? Image.memory(_imageBytes!, fit: BoxFit.contain)
                      : Image.file(_imageFile!, fit: BoxFit.contain),
            ),
            const SizedBox(height: 20),
            if (_isLoading) // Display the loading indicator while generating caption
              const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearImage,
              child: const Text('Clear Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _generateCaption,
              child: const Text('Generate Caption'),
            ),
          ],
        ),
      ),
    );
  }
}
