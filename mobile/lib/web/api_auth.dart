import '../models/token_data.dart';
import 'api_client.dart';
import 'webservice.dart';

class ApiAuth {
  static Future<TokenData> login(String login, String password, String fcmToken) {
    return WebService.send(Method.POST, ApiClient.URL + '/user/login',
        body: {'login': login, 'password': password, 'fcmToken': fcmToken}, parser: (json) => TokenData.fromJson(json));
  }

  static Future<TokenData> getAuthToken(String login, String password, String fcmToken) {
    return WebService.send(Method.POST, ApiClient.URL + '/user/login',
        body: {'login': login, 'password': password, 'fcmToken': fcmToken}, parser: (json) => TokenData.fromJson(json));
  }
}
