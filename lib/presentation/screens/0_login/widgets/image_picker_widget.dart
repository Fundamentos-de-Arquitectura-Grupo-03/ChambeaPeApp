import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerWidget extends StatelessWidget {
  final VoidCallback onTap;
  final File? selectedImage;

  const ImagePickerWidget({
    super.key,
    required this.onTap,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: selectedImage != null ? 150 : 70,
        width: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: selectedImage != null
              ? Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                )
              : const Row(
                  children: [
                    Icon(Icons.add_circle),
                    SizedBox(width: 8),
                    Text("Seleccionar imagen"),
                  ],
                ),
        ),
      ),
    );
  }
}
