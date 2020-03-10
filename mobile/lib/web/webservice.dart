import 'dart:convert';

import 'package:http/http.dart' as http;

import '../exception.dart';
import '../utils/jwt_util.dart';
import '../utils/navigator.dart';
import 'api_client.dart';

class Resource<T> {
  final String url;
  final T Function(dynamic json) parser;

  Resource(this.url, {this.parser});
}

class BodyRes<T> extends Resource<T> {
  final Map<String, dynamic> body;
  final bool isForm;

  BodyRes(url, this.body, {parser, this.isForm = false}) : super(url, parser: parser);
}

enum Method { GET, POST }

class WebService {
  static Future<T> send<T>(Method method, String url,
      {Map<String, dynamic> body, bool isForm = false, T Function(dynamic json) parser}) async {
    Map<String, String> headers = await _prepareHeaders(url, isForm);
    dynamic bbody = isForm ? body : json.encode(body);
    http.Response resp = await _makeRequest(method, url, headers, bbody);
    if (_checkCodeAndRepeat(resp.statusCode, true)) {
      headers['Authorization'] = 'Bearer ' + await Jwt.getAuthToken();
      resp = await _makeRequest(method, url, headers, bbody);
      _checkCodeAndRepeat(resp.statusCode, false);
    }
    if (resp.body == null) return null;
    return parser == null ? resp.body : parser(json.decode(resp.body));
  }

  static Future<http.Response> _makeRequest(Method method, String url, Map<String, String> headers, body) {
    print(url);
    switch (method) {
      case Method.POST:
        return http.post(url, headers: headers, body: body);
        break;
      case Method.GET:
        return http.get(url, headers: headers);
        break;
      default:
        throw Exception('Http method not supported');
    }
  }

  static void updateAuthToken() async {
    final response = await http
        .post(ApiClient.URL + '/user/refresh', headers: {'Authorization': 'Bearer ' + await Jwt.getRefreshToken()});
    print(ApiClient.URL + '/user/refresh');
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        await Jwt.saveAuthToken(response.body.substring(1, response.body.length - 2));
        return;
      case 401:
        NavKey.toLoginPage();
        return;
      default:
        throw LoadingException('Failed to update token');
    }
  }

  static Future<Map<String, String>> _prepareHeaders(String url, bool isForm) async {
    Map<String, String> headers =
        (isForm ? {'Content-Type': 'application/x-www-form-urlencoded'} : {'Content-Type': 'application/json'});
    if (!url.endsWith('user/login')) {
      headers['Authorization'] =
          'Bearer ' + (url.endsWith('user/refresh') ? await Jwt.getRefreshToken() : await Jwt.getAuthToken());
    }
    return headers;
  }

  static bool _checkCodeAndRepeat(int code, bool canRepeat) {
    print(code);
    switch (code) {
      case 401:
        if (canRepeat) {
          updateAuthToken();
          return true;
        }
        NavKey.toLoginPage();
        return false;
      case 403:
        throw AuthException();
      case 200:
        return false;
      default:
        throw LoadingException(code.toString());
    }
  }
}
