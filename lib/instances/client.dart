import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
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

  /// Convert UTC date to WIB date
  String convertUtcToWib(String utcDate) {
    try {
      DateTime utcDateTime = DateTime.parse(utcDate);
      DateTime wibDateTime = utcDateTime.add(const Duration(hours: 7));

      return DateFormat("dd MMM yyyy - HH:mm").format(wibDateTime);
    } catch (e) {
      return "Format tanggal tidak valid";
    }
  }
}
