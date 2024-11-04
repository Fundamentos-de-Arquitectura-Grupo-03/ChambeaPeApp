import 'dart:convert';
import 'dart:io';

import 'package:chambeape/infrastructure/models/users_work_img.dart';
import 'package:http_parser/http_parser.dart' as http_parser;

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class UserWorksService {
  final uri =
      Uri.parse('https://chambea-backend-storage.azurewebsites.net/api/users');

  Future<UsersWorkImg> getImageUrlsByUserId(int userId) async {
    final response = await http.get(Uri.parse('$uri/$userId'));
    if (response.statusCode == 200) {
      return UsersWorkImg.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user work images');
    }
  }

  Future<UsersWorkImg> createUserWorkImage(int userId) async {
    final response = await http.post(
      Uri.parse('$uri/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'id_user': userId,
      }),
    );

    if (response.statusCode == 201) {
      return UsersWorkImg.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user work image');
    }
  }

  Future<void> uploadUserImage(int userId, File imageFile) async {
    var request = http.MultipartRequest(
      'PATCH',
      Uri.parse('$uri/$userId/addImageUrl'),
    );

    String? mimeType = lookupMimeType(imageFile.path);
    if (mimeType == null) {
      throw Exception('Could not determine MIME type');
    }

    var mimeTypeParts = mimeType.split('/');
    if (mimeTypeParts.length != 2) {
      throw Exception('Invalid MIME type');
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: http_parser.MediaType(mimeTypeParts[0], mimeTypeParts[1]),
      ),
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed with status: ${response.statusCode}');
        // Datos del error
        response.stream.bytesToString().then((value) {
          print(value);
        });
      }
    } catch (e) {
      print('Error occurred while uploading image: $e');
    }
  }

  Future<UsersWorkImg> createUserIfNotExists(int userId) async {
    try {
      return await getImageUrlsByUserId(userId);
    } catch (e) {
      print('User does not exist');
      return await createUserWorkImage(userId);
    }
  }
}
