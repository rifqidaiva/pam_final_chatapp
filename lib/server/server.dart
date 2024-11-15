import 'package:dio/dio.dart';

class Server {
  static final Server _instance = Server._internal();
  final Dio _dio = Dio();

  factory Server() {
    return _instance;
  }

  Server._internal() {
    _dio.options.baseUrl = "http://localhost:8080";
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
  }

  void login({
    required String email,
    required String password,
    required Function(String) onSucess,
    required Function(DioException) onError,
  }) async {
    try {
      var response = await _dio.post(
        "/login",
        queryParameters: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        onSucess(response.data["token"]);
      } else {
        onError(DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: "${response.data["message"]}",
          error: "login gagal dengan status: ${response.statusCode}",
        ));
      }
    } on DioException catch (e) {
      onError(e);
    }
  }

  void register({
    required String email,
    required String password,
    required String name,
    required Function onSucess,
    required Function(DioException) onError,
  }) async {
    try {
      var response = await _dio.post(
        "/register",
        queryParameters: {
          "email": email,
          "password": password,
          "name": name,
        },
      );

      if (response.statusCode == 200) {
        onSucess();
      } else {
        onError(DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: "${response.data["message"]}",
          error: "registrasi gagal dengan status: ${response.statusCode}",
        ));
      }
    } on DioException catch (e) {
      onError(e);
    }
  }

  // Get user data from token
  void getUserFromToken({
    required String token,
    required Function(User) onSucess,
    required Function(DioException) onError,
  }) async {
    try {
      var response = await _dio.get(
        "/user",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        onSucess(User.fromJson(response.data));
      } else {
        onError(DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: "${response.data["message"]}",
          error:
              "gagal mendapatkan data user dengan status: ${response.statusCode}",
        ));
      }
    } on DioException catch (e) {
      onError(e);
    }
  }
}

User? currentUser;

class User {
  final int id;
  final String email;
  final String name;
  final String? token;

  User({required this.id, required this.email, required this.name, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        token: json["token"]);
  }
}
