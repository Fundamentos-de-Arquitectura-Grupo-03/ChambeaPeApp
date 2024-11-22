import 'package:flutter/material.dart';

class DialogConfirmationDialogWidget extends StatelessWidget {
  final String title;
  final String descrpition;
  final String postTitle;

  const DialogConfirmationDialogWidget({
    super.key,
    required this.title,
    required this.descrpition,
    required this.postTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(title),
      ),
      content: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                descrpition,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 15,
              ),
              //Centrar el texto
              Center(
                child: Text(
                  postTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
