import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:chambeape/infrastructure/models/chat_message.dart';

class MessageService {
  final String baseUrl =
      'https://chambeape-chat.azurewebsites.net/api/chat/messages';
  final http.Client? client;

  MessageService({this.client});

  Future<List<ChatMessage>> getMessages(String roomId,
      {bool latest = false}) async {
    final queryParameters = {
      'roomId': roomId,
    };
    if (latest) {
      queryParameters['latest'] = 'true';
    }
    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
    final response = await (client ?? http.Client()).get(uri);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      List<ChatMessage> messages =
          body.map((dynamic item) => ChatMessage.fromJson(item)).toList();
      return messages;
    } else {
      throw Exception(
          'Failed to fetch messages: Status Code ${response.statusCode}, Response Body: ${response.body}');
    }
  }
}
