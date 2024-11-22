import 'package:chambeape/config/databases/db_helper.dart';
import 'package:chambeape/infrastructure/models/workers.dart';
import 'package:chambeape/presentation/screens/5_profile/profile_view.dart';
import 'package:chambeape/presentation/screens/chat/chat_view.dart';
import 'package:flutter/material.dart';

class UserCardWidget extends StatefulWidget {
  final Workers worker;

  const UserCardWidget({required this.worker, super.key});

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  final DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.amber.shade700.withOpacity(0.35),
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.worker.profilePic),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.worker.firstName} ${widget.worker.lastName}',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.worker.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _WorkersButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatView(
                                otherUser: widget.worker.toUser(),
                              ),
                            ),
                          );
                        },
                        text: 'Chat',
                      ),
                      const Spacer(),
                      _WorkersButton(
                        onPressed: () async {
                          await dbHelper.insertUser(widget.worker.toUser());

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileView(
                                userId: widget.worker.id,
                              ),
                            ),
                          );
                        },
                        text: 'Ver Perfil',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkersButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  final buttonStyle = ButtonStyle(
    minimumSize: WidgetStateProperty.resolveWith(
      (states) => const Size(110, 30),
    ),
  );

  _WorkersButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
