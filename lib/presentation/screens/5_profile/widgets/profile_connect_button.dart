import 'package:chambeape/infrastructure/models/users.dart';
import 'package:chambeape/presentation/screens/chat/chat_view.dart';
import 'package:flutter/material.dart';

class ConnectButton extends StatefulWidget {
  final TextTheme text;

  final Users user;

  const ConnectButton({
    super.key,
    required this.text,
    required this.user,
  });

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(5), // Ajusta el radio del borde aquí
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatView(
                otherUser: widget.user,
              ),
            ),
          );
        },
        child: Text('Chatear',
            style: widget.text.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
