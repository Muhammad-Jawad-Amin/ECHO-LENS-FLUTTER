import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CaptionScreen extends StatefulWidget {
  final File? imageFile;
  final Uint8List? imageBytes;
  final String caption;

  const CaptionScreen(
      {super.key, this.imageFile, this.imageBytes, required this.caption});

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
    }
  }

  Future<void> _replay() async {
    // Stop any ongoing speech and replay from the beginning
    await _stop();
    _speak(widget.caption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caption Screen'),
      ),
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
              child: widget.imageFile == null && widget.imageBytes == null
                  ? const Text('No image available.')
                  : kIsWeb
                      ? Image.memory(widget.imageBytes!, fit: BoxFit.contain)
                      : Image.file(widget.imageFile!, fit: BoxFit.contain),
            ),
            const SizedBox(height: 20),
            Text(widget.caption),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: isPlaying ? _pause : _resume,
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: _stop,
                ),
                IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: _replay,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
