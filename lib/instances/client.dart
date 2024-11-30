import 'package:dio/dio.dart';
import 'package:pam_final_client/instances/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Client {
  void setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  void removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }

  void getUser({
    required Function(User) onSuccess,
    required Function(DioException) onError,
  }) async {
    var token = await getToken();

    return Server().getUserFromToken(
      token: token,
      onSuccess: (user) {
        onSuccess(user);
      },
      onError: (e) {
        onError(e);
      },
    );
  }

  Future<void> setIsListening(bool isListening) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("isListening", isListening.toString());
  }

  Future<bool> getIsListening() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("isListening") == "true";
  }
}
