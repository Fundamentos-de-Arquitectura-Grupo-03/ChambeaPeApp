import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UriEnvironment {
  static const String baseUrl = 'https://chambeapeapi-a4anbthqamgre7ce.eastus-01.azurewebsites.net/api/v1';

  static Future<Uri> getPostUri() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String userData = prefs.getString('user') ?? '';
    final Map<String, dynamic> userDataJson = jsonDecode(userData);

    int id = userDataJson['id'];

    final Uri uri = Uri.parse('$baseUrl/employers/$id/posts');

    return uri;
  }
}
