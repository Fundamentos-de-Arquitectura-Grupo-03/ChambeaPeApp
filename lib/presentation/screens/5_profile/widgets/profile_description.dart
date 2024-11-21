import 'package:chambeape/infrastructure/models/users.dart';
import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final TextTheme text;

  const Description({
    super.key, 
    required this.user,
    required this.text,
  });

  final Users user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Descripción',
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text(user.description,
                style: text.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}