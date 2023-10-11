import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String ip = '192.168.1.178';
String urlHead = 'http://$ip:8080/api';

class APIs {
  Future<dynamic> fetchPosts() async {
    String url = '$urlHead/getPosts';

    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var data = decodedResponse['data'];
        return data;
      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<String> addPosts(String imgURL) async {
    String url = '$urlHead/addPost';
    try {
      final response =
          await http.post(Uri.parse(url), body: {'imageURL': imgURL});
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        String data = decodedResponse['message'];
        return data;
      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    throw Exception('Error');
  }

  Future<String> getURL(String imgPath) async {
    try {
      String url = 'https://api.cloudinary.com/v1_1/dgzhhxt7d/image/upload';

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('file', imgPath));
      request.fields['upload_preset'] = 'gallery';
      request.fields['folder'] = 'gallery';

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(responseBody);
        String result = decodedResponse['secure_url'];
        if (kDebugMode) {
          print(decodedResponse);
        }
        return result;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image to Cloudinary: $e');
      }
      throw Exception('Failed to upload image');
    }
  }

  Future<String> pickAndUploadImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        String filePath = result.files.single.path!;
        String message = await getURL(filePath);
        return message;
      } else {
        if (kDebugMode) {
          print('User canceled file selection.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking and uploading image: $e');
      }
    }
    throw Exception('Error');
  }
}
