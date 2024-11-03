import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:chambeape/services/login/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Login Service Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Login exitoso', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'id': 1,
            'firstName': 'John',
            'lastName': 'Doe',
            'email': 'user@example.com',
            'phoneNumber': '123456789',
            'birthdate': '1990-01-01T00:00:00.000',
            'gender': 'male',
            'profilePic': 'profilePic.png',
            'description': 'User description',
            'userRole': 'user',
            'hasPremium': 1,
          }),
          200,
        );
      });

      // Act
      final loginResult = await login('user@example.com', 'correctPassword',
          client: mockClient);

      // Assert
      expect(loginResult.email, equals('user@example.com'));
    });

    test('Login fallido', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Credenciales incorrectas', 401);
      });

      // Act & Assert
      expect(
        () async => await login('user@example.com', 'wrongPassword',
            client: mockClient),
        throwsException,
      );
    });
  });
}
