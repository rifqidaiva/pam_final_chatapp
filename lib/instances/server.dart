import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:pam_final_client/instances/client.dart';

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

  // MARK: /ws
  /// Connect to WebSocket
  WebSocketChannel ws() {
    final wsUrl = Uri.parse('ws://localhost:8080/ws');
    return WebSocketChannel.connect(wsUrl);
  }

  // MARK: /login
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

  // MARK: /register
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

  // MARK: /user
  /// Get user data from token
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

  // MARK: /user?id=
  /// Get user data by id
  void getUserById({
    required int id,
    required Function(User) onSucess,
    required Function(DioException) onError,
  }) async {
    try {
      String token = await Client().getToken() ?? "";

      var response = await _dio.get(
        "/user",
        queryParameters: {
          "id": id,
        },
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

  // MARK: /users
  /// Get all users except the current user
  void getUsers({
    required Function(List<User>) onSucess,
    required Function(DioException) onError,
  }) async {
    try {
      String token = await Client().getToken() ?? "";

      var response = await _dio.get(
        "/users",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<User> users = [];
        for (var user in response.data) {
          users.add(User.fromJson(user));
        }
        onSucess(users);
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

  // MARK: /conversation
  /// Get conversation between current user and another user
  void getConversation({
    required int userId,
    required Function(List<Message>) onSucess,
    required Function(DioException) onError,
  }) async {
    try {
      String token = await Client().getToken() ?? "";

      var response = await _dio.get(
        "/conversation",
        queryParameters: {
          "userId": userId,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<Message> messages = [];
        for (var message in response.data) {
          messages.add(Message.fromJson(message));
        }
        onSucess(messages);
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

  // MARK: /allmessages
  /// Get all messages from the current user
  void getAllMessages({
    required Function(List<Message>) onSucess,
    required Function(DioException) onError,
  }) async {
    try {
      String token = await Client().getToken() ?? "";

      var response = await _dio.get(
        "/allmessages",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<Message> messages = [];
        for (var message in response.data) {
          messages.add(Message.fromJson(message));
        }
        onSucess(messages);
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

class User {
  int id;
  String email;
  String name;
  String? token;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      token: json["token"],
    );
  }
}

class Message {
  int id;
  int senderId;
  int receiverId;
  String message;
  String timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      senderId: json["sender_id"],
      receiverId: json["receiver_id"],
      message: json["content"],
      timestamp: json["timestamp"],
    );
  }
}
