import 'dart:convert';
import 'package:chambeape/config/utils/login_user_data.dart';
import 'package:chambeape/infrastructure/models/login/login_response.dart';
import 'package:chambeape/infrastructure/models/users.dart';
import 'package:chambeape/services/chat/chat_list_service.dart';
import 'package:http/http.dart' as http;

class UserService {
  final Uri uri = Uri.parse(
      'https://chambeapeapi-a4anbthqamgre7ce.eastus-01.azurewebsites.net/api/v1/users');
  final http.Client? client;

  UserService({this.client});

  Future<List<Users>> getUsers() async {
    final response = await (client ?? http.Client()).get(uri);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      List<Users> users =
          body.map((dynamic item) => Users.fromJson(item)).toList();
      return users;
    } else {
      throw Exception(
          'Failed to fetch users: Status Code ${response.statusCode}, Response Body: ${response.body}');
    }
  }

  Future<Users> postUser(Users user) async {
    final response = await (client ?? http.Client()).post(
      uri,
      body: json.encode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Users.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception(
          'Failed to post user: Status Code ${response.statusCode}, Response Body: ${response.body}');
    }
  }

  Future<Users> getUserById(int id) async {
    final response = await (client ?? http.Client()).get(Uri.parse('$uri/$id'));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Users.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception(
          'Failed to fetch user by id: Status Code ${response.statusCode}, Response Body: ${response.body}');
    }
  }

  Future<List<Users>> getExistingChatUsers() async {
    LoginResponse user = LoginData().user;
    user = await LoginData().loadSession();
    var userId = user.id;

    ChatListService chatListService = ChatListService();
    List<String> existingChatUsersId =
        await chatListService.getExistingChatUsersId(userId.toString());
    List<Users> existingChatUsers = [];

    for (var id in existingChatUsersId) {
      final response =
          await (client ?? http.Client()).get(Uri.parse('$uri/$id'));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        existingChatUsers
            .add(Users.fromJson(json.decode(utf8.decode(response.bodyBytes))));
      } else {
        throw Exception(
            'Failed to fetch user by id: Status Code ${response.statusCode}, Response Body: ${response.body}');
      }
    }

    return existingChatUsers;
  }
}
