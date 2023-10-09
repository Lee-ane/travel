import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String urlHead = 'http://172.16.4.130:8080/api';

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
    String data = '';

    final response = await http.post(Uri.parse(url),
        body: json.encode({'imageURL': imgURL}));
    try {
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        data = decodedResponse['message'];
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
    return data;
  }
}
