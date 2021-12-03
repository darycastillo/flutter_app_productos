import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyCEzJYZfz-sotSRTD8Mc0G9n99oC0q0uGM';
  final storage = const FlutterSecureStorage();

  Future<String?> crateuser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        Uri.https(_baseUrl, 'v1/accounts:signUp', {'key': _firebaseToken});
    final request = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(request.body);

    if (decodedData.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedData['idToken']);
      return null;
    } else {
      return decodedData['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(
        _baseUrl, 'v1/accounts:signInWithPassword', {'key': _firebaseToken});
    final request = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(request.body);

    if (decodedData.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedData['idToken']);
      return null;
    } else {
      return decodedData['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> isAuthenticated() async {
    return await storage.read(key: 'token') ?? '';
  }
}
