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

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await _dio.post("/login", data: {
      "email": email,
      "password": password,
    });
  }

  Future<Response> register({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _dio.post(
      "/register",
      queryParameters: {
        "email": email,
        "password": password,
        "name": name,
      },
    );
  }

  // Test endpoint
  Future<Response> test() async {
    return await _dio.get("/test");
  }
}

User? currentUser;

class User {
  final int id;
  final String email;
  final String name;

  User({required this.id, required this.email, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json["id"], email: json["email"], name: json["name"]);
  }

  factory User.fromJwt(Map<String, dynamic> jwt) {
    return User(id: jwt["id"], email: jwt["email"], name: jwt["name"]);
  }
}
