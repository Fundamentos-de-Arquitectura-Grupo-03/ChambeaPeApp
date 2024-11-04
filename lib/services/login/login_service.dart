import 'package:chambeape/infrastructure/models/login/login_response.dart';
import 'package:chambeape/infrastructure/models/login/log_in.dart';
import 'package:chambeape/services/login/session_service.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Login> login(String email, String password,
    {http.Client? client}) async {
  client ??= http.Client();

  Map<String, dynamic> requestBody = {
    'email': email,
    'password': password,
  };

  final uri = Uri.parse(
      'https://chambeapeapi-a4anbthqamgre7ce.eastus-01.azurewebsites.net/api/v1/users/login');

  final response = await client.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    final responseBody = utf8.decode(response.bodyBytes);

    final Map<String, dynamic> jsonResponse = json.decode(responseBody);

    Login login = Login.fromJson(jsonResponse);
    LoginResponse user = LoginResponse.fromJson(jsonResponse);

    await SessionService().saveSession(user);

    return login;
  } else {
    throw Exception('Failed to login');
  }
}
