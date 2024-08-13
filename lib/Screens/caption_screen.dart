import 'dart:io';
import 'package:echo_lens/Widgets/colors_global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CaptionScreen extends StatefulWidget {
  final File? imageFile;
  final Uint8List? imageBytes;
  final Widget? image;
  final String caption;

  const CaptionScreen({
    super.key,
    this.imageFile,
    this.imageBytes,
    this.image,
    required this.caption,
  });

  @override
  State<CaptionScreen> createState() => _CaptionScreenState();
}

class _CaptionScreenState extends State<CaptionScreen> {
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  bool isPaused = false;
  String? remainingText;

  @override
  void initState() {
    super.initState();
    _speak(widget.caption);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);

    setState(() {
      isPlaying = true;
      isPaused = false;
      remainingText = text; // Save the full text for replay
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
        isPaused = false;
        remainingText = null; // Reset remaining text when done
      });
    });
  }

  Future<void> _pause() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      isPaused = true;
    });
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      isPaused = false;
      remainingText = null; // Reset remaining text
    });
  }

  Future<void> _resume() async {
    if (remainingText != null) {
      _speak(remainingText!);
    } else {
      _speak(widget.caption);
    }
  }

  Future<void> _replay() async {
    // Stop any ongoing speech and replay from the beginning
    await _stop();
    _speak(widget.caption);
  }

  Widget? getImagetoDisplay() {
    if (widget.imageFile == null &&
        widget.imageBytes == null &&
        widget.image == null) {
      return const Text('No image available.');
    } else if (kIsWeb && widget.imageBytes != null && widget.image == null) {
      return Image.memory(widget.imageBytes!, fit: BoxFit.cover);
    } else if (widget.imageFile != null && widget.image == null) {
      return Image.file(widget.imageFile!, fit: BoxFit.cover);
    } else {
      return widget.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.themeColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GlobalColors.themeColor,
        title: Text(
          'C A P T I O N   P A G E',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                color: GlobalColors
                    .mainColor, // Custom color for the hamburger icon
                onPressed: () {
                  Navigator.of(context).pop(); // Open the drawer
                },
              );
            },
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "You can listen the generated caption by playing, pausing and stoping the audio.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GlobalColors.mainColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 30,
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
                child: getImagetoDisplay(),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.all(30),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: GlobalColors.mainColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      "GENERATED CAPTION",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: GlobalColors.mainColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.caption,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: GlobalColors.textColor,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: GlobalColors.mainColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      "AUDIO CONTROLLER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: GlobalColors.mainColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: GlobalColors.mainColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            color: GlobalColors.textColor,
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow),
                            onPressed: isPlaying ? _pause : _resume,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: GlobalColors.mainColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            color: GlobalColors.textColor,
                            icon: const Icon(Icons.stop),
                            onPressed: _stop,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: GlobalColors.mainColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            color: GlobalColors.textColor,
                            icon: const Icon(Icons.replay),
                            onPressed: _replay,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
