import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:chambeape/services/users/user_service.dart';
import 'package:chambeape/infrastructure/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Registration Service Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Registro exitoso', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'id': 1,
            'firstName': 'Jane',
            'lastName': 'Doe',
            'email': 'jane.doe@example.com',
            'phoneNumber': '123456789',
            'birthdate': '1990-01-01',
            'gender': 'female',
            'hasPremium': 1,
            'profilePic': 'profilePicUri',
            'description': 'User description',
            'userRole': 'user',
            'isVisible': 'true',
            'dni': '123456789',
          }),
          201,
        );
      });
      final userService = UserService(client: mockClient);
      Users newUser = Users(
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane.doe@example.com',
        phoneNumber: '123456789',
        birthdate: DateTime.now(),
        gender: 'female',
        profilePic: 'profilePicUri',
        description: 'User description',
        userRole: 'user',
        dni: '123456789',
        password: 'ValidPassword123',
      );

      // Act
      final registrationResult = await userService.postUser(newUser);

      // Assert
      expect(registrationResult.email, equals('jane.doe@example.com'));
    });

    test('Registro fallido - Correo Inválido', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Correo electrónico inválido', 400);
      });
      final userService = UserService(client: mockClient);
      Users newUser = Users(
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'invalid-email',
        phoneNumber: '123456789',
        birthdate: DateTime.now(),
        gender: 'female',
        profilePic: 'profilePicUri',
        description: 'User description',
        userRole: 'user',
        dni: '123456789',
        password: 'ValidPassword123',
      );

      // Act & Assert
      expect(() async => await userService.postUser(newUser), throwsException);
    });

    test('Registro fallido - Contraseña Inválida', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Contraseña inválida', 400);
      });
      final userService = UserService(client: mockClient);
      Users newUser = Users(
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane.doe@example.com',
        phoneNumber: '123456789',
        birthdate: DateTime.now(),
        gender: 'female',
        profilePic: 'profilePicUri',
        description: 'User description',
        userRole: 'user',
        dni: '123456789',
        password: '123',
      );

      // Act & Assert
      expect(() async => await userService.postUser(newUser), throwsException);
    });
  });
}
