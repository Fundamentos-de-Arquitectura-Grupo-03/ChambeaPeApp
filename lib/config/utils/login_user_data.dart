import 'dart:convert';

import 'package:chambeape/infrastructure/models/login/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginData {
  LoginResponse user = LoginResponse(
    id: 0,
    firstName: '',
    lastName: '',
    email: '',
    phoneNumber: '',
    birthdate: DateTime.now(),
    gender: '',
    profilePic: '',
    description: '',
    userRole: '',
  );

  Future<LoginResponse> loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userData = prefs.getString('user') ?? '';
    if (userData.isEmpty) {
      final LoginResponse user = LoginResponse(
        id: 0,
        firstName: '',
        lastName: '',
        email: '',
        phoneNumber: '',
        birthdate: DateTime.now(),
        gender: '',
        profilePic: '',
        description: '',
        userRole: '',
      );

      return user;
    }
    final Map<String, dynamic> userDataJson = jsonDecode(userData);
    final LoginResponse user = LoginResponse.fromJson(userDataJson);

    return user;
  }
}
