import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/token_data.dart';

class Jwt {
  static final _storage = FlutterSecureStorage();

  static Future<String> getAuthToken() async => await _storage.read(key: "auth");

  static Future<String> getRefreshToken() async => await _storage.read(key: "refresh");

  static Future<void> saveAuthToken(String token) async => await _storage.write(key: "auth", value: token);

  static Future<void> saveTokens(TokenData tokens) async {
    await _storage.write(key: "refresh", value: tokens.refreshToken);
    await _storage.write(key: "auth", value: tokens.authToken);
  }

  static Future<void> delete() async => await _storage.deleteAll();

  static bool checkIsExpired(String token) {
    return DateTime.now().millisecondsSinceEpoch / 1000 >= _parseJwt(token)['exp'];
  }

  static Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }
    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }
    return utf8.decode(base64Url.decode(output));
  }
}
