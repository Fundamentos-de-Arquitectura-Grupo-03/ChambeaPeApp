import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:chambeape/services/postulation/postulation_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Postulation Service Tests', () {
    test('Postulación exitosa', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('{}', 201);
      });
      final postulationService = PostulationService(client: mockClient);

      // Act
      await postulationService.createPostulation(1, 100);

      // Assert
      expect(mockClient, isNotNull);
    });

    test('Seguimiento de Postulaciones', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {
              'postId': 1,
              'worker': {'id': 100},
              'status': 'Pending',
            }
          ]),
          200,
        );
      });
      final postulationService = PostulationService(client: mockClient);

      // Act
      final postulations =
          await postulationService.getPostulationsByWorkerId(100);

      // Assert
      expect(postulations.isNotEmpty, true);
      expect(postulations.first['status'], equals('Pending'));
    });

    test('Error en la Postulación', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Error al crear la postulación', 400);
      });
      final postulationService = PostulationService(client: mockClient);

      // Act & Assert
      expect(
        () async => await postulationService.createPostulation(1, 100),
        throwsException,
      );
    });
  });
}
