import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:echo_lens/Widgets/drawer_global.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:echo_lens/Services/auth_service.dart';
import 'package:echo_lens/Services/storage_service.dart';
import 'package:echo_lens/Services/firestore_service.dart';
import 'package:echo_lens/Services/api_service.dart';
import 'package:echo_lens/Screens/caption_screen.dart';
import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:echo_lens/Widgets/button_global.dart';

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

  void showerrormessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: GlobalColors.textColor,
      ),
    );
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage(BuildContext context, bool camera) async {
    final picker = ImagePicker();
    final XFile? pickedFile;

    if (camera) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

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
          _imageFile = File(pickedFile!.path);
          _imageBytes = null; // Clear bytes reference on mobile
        });
      }
    } else {
      if (!context.mounted) return;
      showerrormessage(context, 'No image selected.');
    }
  }

  // Method to generate a caption for the selected image
  Future<void> _generateCaption() async {
    if (_imageFile == null && _imageBytes == null) return;

    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none && mounted) {
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
      backgroundColor: GlobalColors.themeColor,
      drawer: const DrawerGlobal(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GlobalColors.themeColor,
        title: Text(
          'H O M E   P A G E',
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
      body: Stack(
        children: [
          // The main content of the screen
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Pick or click your desired image and then generate a caption.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: GlobalColors.mainColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: 300, // Set the width of the image container
                      height: 300, // Set the height of the image container
                      decoration: BoxDecoration(
                        border: Border.all(color: GlobalColors.mainColor),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: GlobalColors.mainColor.withOpacity(0.25),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: _imageFile == null && _imageBytes == null
                          ? Center(
                              child: Text(
                                'No image selected.',
                                style: TextStyle(
                                  color: GlobalColors.mainColor,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : kIsWeb
                              ? Image.memory(_imageBytes!, fit: BoxFit.contain)
                              : Image.file(_imageFile!, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 40),
                    ButtonGlobal(
                      buttontext: 'Pick Image From Gallery',
                      textsize: 20,
                      onPressed: () {
                        _pickImage(context, false);
                      },
                    ),
                    const SizedBox(height: 10),
                    ButtonGlobal(
                      buttontext: 'Click Image Using Camera',
                      textsize: 20,
                      onPressed: () {
                        _pickImage(context, true);
                      },
                    ),
                    const SizedBox(height: 10),
                    ButtonGlobal(
                      buttontext: 'Clear Image',
                      textsize: 20,
                      onPressed: _clearImage,
                    ),
                    const SizedBox(height: 10),
                    ButtonGlobal(
                      buttontext: 'Generate Caption',
                      textsize: 20,
                      onPressed: _generateCaption,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // The loading indicator with a modal barrier
          if (_isLoading)
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withOpacity(0.5),
            ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: GlobalColors.mainColor,
              ),
            ),
        ],
      ),
    );
  }
}
