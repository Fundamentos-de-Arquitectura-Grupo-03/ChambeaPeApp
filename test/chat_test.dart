import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:chambeape/services/chat/message_service.dart';
import 'package:chambeape/services/chat/chat_list_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Chat and Message Service Tests', () {
    test('Iniciar chat sin contacto previo', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('["100"]', 200);
      });
      final chatListService = ChatListService(client: mockClient);

      // Act
      final users = await chatListService.getExistingChatUsersId("1");

      // Assert
      expect(users.isNotEmpty, true);
    });

    test('Visualizar el registro del chat', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {
              'content': 'Hola',
              'type': 'text',
              'user': 'empleador',
              'timestamp': '2024-09-25 10:00:00'
            }
          ]),
          200,
        );
      });
      final messageService = MessageService(client: mockClient);

      // Act
      final messages = await messageService.getMessages("room1");

      // Assert
      expect(messages.isNotEmpty, true);
      expect(messages.first.content, equals('Hola'));
    });

    test('Notificaciones de nuevos mensajes', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {
              'content': 'Nuevo mensaje',
              'type': 'text',
              'user': 'chambeador',
              'timestamp': '2024-09-25 11:00:00'
            }
          ]),
          200,
        );
      });
      final messageService = MessageService(client: mockClient);

      // Act
      final latestMessages =
          await messageService.getMessages("room1", latest: true);

      // Assert
      expect(latestMessages.isNotEmpty, true);
      expect(latestMessages.first.content, equals('Nuevo mensaje'));
    });

    test('Error al obtener mensajes', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Error al obtener mensajes', 400);
      });
      final messageService = MessageService(client: mockClient);

      // Act & Assert
      expect(
        () async => await messageService.getMessages("room1"),
        throwsException,
      );
    });
  });
}
