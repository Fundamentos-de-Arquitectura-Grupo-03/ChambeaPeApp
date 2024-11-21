import 'dart:io';

import 'package:flutter/material.dart';
class StepperPostState {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController categoryController;
  final TextEditingController locationController;
  final bool hasNotification;
  final int hasPremium;
  final bool hasImageSelected;
  final File? selectedImage;
  final GlobalKey<FormState> formKeyPostDetails;
  final GlobalKey<FormState> formKeyPostLocation;

  StepperPostState({
    required this.titleController,
    required this.descriptionController,
    required this.categoryController,
    required this.locationController,
    this.hasNotification = false,
    this.hasPremium = 0,
    required this.hasImageSelected,
    this.selectedImage,
    required this.formKeyPostDetails,
    required this.formKeyPostLocation,
  });

  StepperPostState copyWith({
    TextEditingController? titleController,
    TextEditingController? descriptionController,
    TextEditingController? categoryController,
    TextEditingController? locationController,
    bool? hasNotification,
    int? hasPremium,
    bool? hasImageSelected,
    File? selectedImage,

  }) {
    return StepperPostState(
      titleController: titleController ?? this.titleController,
      descriptionController: descriptionController ?? this.descriptionController,
      categoryController: categoryController ?? this.categoryController,
      locationController: locationController ?? this.locationController,
      hasNotification: hasNotification ?? this.hasNotification,
      hasImageSelected: hasImageSelected ?? this.hasImageSelected,
      hasPremium: hasPremium ?? this.hasPremium,
      selectedImage: selectedImage ?? this.selectedImage,
      formKeyPostDetails: formKeyPostDetails,
      formKeyPostLocation: formKeyPostLocation,
    );
  }
}