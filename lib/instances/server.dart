import 'package:dio/dio.dart';
import 'package:pam_final_client/instances/client.dart';

class Server {
  static final Server _instance = Server._internal();
  final Dio _dio = Dio();

  factory Server() {
    return _instance;
  }

  Server._internal() {
    _dio.options.baseUrl = "https://3bab-182-253-126-0.ngrok-free.app";
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
  }

  // MARK: /login
  void login({
    required String email,
    required String password,
    required Function(String) onSuccess,
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
        onSuccess(response.data["token"]);
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
    required Function onSuccess,
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
        onSuccess();
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
    required Function(User) onSuccess,
    required Function(DioException) onError,
  }) async {
    try {
      var response = await _dio.get(
        "/user",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "ngrok-skip-browser-warning": "true",
          },
        ),
      );

      if (response.statusCode == 200) {
        onSuccess(User.fromJson(response.data));
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
    required Function(User) onSuccess,
    required Function(DioException) onError,
  }) async {
    try {
      String token = await Client().getToken();

      var response = await _dio.get(
        "/user",
        queryParameters: {
          "id": id,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "ngrok-skip-browser-warning": "true",
          },
        ),
      );

      if (response.statusCode == 200) {
        onSuccess(User.fromJson(response.data));
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
    required Function(List<User>) onSuccess,
    required Function(DioException) onError,
  }) async {
    try {
      String token = await Client().getToken();

      var response = await _dio.get(
        "/users",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "ngrok-skip-browser-warning": "true",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<User> users = [];
        for (var user in response.data) {
          users.add(User.fromJson(user));
        }
        onSuccess(users);
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
    required int otherUserId,
    required Function(List<Message>) onSuccess,
    required Function(DioException) onError,
  }) async {
    try {
      String token = await Client().getToken();

      var response = await _dio.get(
        "/conversation",
        queryParameters: {
          "other_user_id": otherUserId,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "ngrok-skip-browser-warning": "true",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<Message> messages = [];
        for (var message in response.data) {
          messages.add(Message.fromJson(message));
        }
        onSuccess(messages);
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
    required Function(List<Message>) onSuccess,
    required Function(DioException) onError,
  }) async {
    try {
      String token = await Client().getToken();

      var response = await _dio.get(
        "/allmessages",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "ngrok-skip-browser-warning": "true",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<Message> messages = [];
        for (var message in response.data) {
          messages.add(Message.fromJson(message));
        }
        onSuccess(messages);
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

  // MARK: /preferences [GET]
  /// Get user preferences
  void getPreferences({
    required Function(Preferences) onSuccess,
    required Function(DioException) onError,
  }) async {
    try {
      String token = await Client().getToken();

      var response = await _dio.get(
        "/preferences",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "ngrok-skip-browser-warning": "true",
          },
        ),
      );

      if (response.statusCode == 200) {
        onSuccess(Preferences.fromJson(response.data));
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

  // MARK: /preferences [PUT]
  /// Update user preferences
  void updatePreferences({
    required Preferences preferences,
    required Function onSuccess,
    required Function(DioException) onError,
  }) async {
    try {
      String token = await Client().getToken();

      var response = await _dio.put(
        "/preferences",
        data: preferences.toJson(),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "ngrok-skip-browser-warning": "true",
          },
        ),
      );

      if (response.statusCode == 200) {
        onSuccess();
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
  int? id;
  int senderId;
  int receiverId;
  String content;
  String? timestamp;

  Message({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      senderId: json["sender_id"],
      receiverId: json["receiver_id"],
      content: json["content"],
      timestamp: json["timestamp"],
    );
  }

  // To json string method
  String toJson() {
    return """
    {
      "id": $id,
      "sender_id": $senderId,
      "receiver_id": $receiverId,
      "content": "$content",
      "timestamp": "$timestamp"
    }
    """;
  }
}

class Preferences {
  String mode;
  String theme;
  String timeZone;
  String currency;
  bool isPremium;

  Preferences({
    required this.mode,
    required this.theme,
    required this.timeZone,
    required this.currency,
    required this.isPremium,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      mode: json["mode"],
      theme: json["theme"],
      timeZone: json["time_zone"],
      currency: json["currency"],
      isPremium: json["is_premium"],
    );
  }

  // To json string method
  String toJson() {
    return """
    {
      "mode": "$mode",
      "theme": "$theme",
      "time_zone": "$timeZone",
      "currency": "$currency",
      "is_premium": $isPremium
    }
    """;
  }
}
