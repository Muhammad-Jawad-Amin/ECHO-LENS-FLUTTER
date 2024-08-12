import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://192.168.10.13:5000/generate_caption';

  static Future<String?> generateCaption(File image) async {
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);
      return data['caption'];
    } else {
      print('Error generating caption: ${response.statusCode}');
      return null;
    }
  }

  // New method to handle image bytes (for Flutter Web)
  static Future<String?> generateCaptionFromBytes(Uint8List bytes) async {
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(
        http.MultipartFile.fromBytes('image', bytes, filename: 'image.jpg'));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);
      return data['caption'];
    } else {
      print('Error generating caption: ${response.statusCode}');
      return null;
    }
  }
}
