import 'dart:io';
import 'package:chambeape/presentation/providers/posts/steps/stepper_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stepperPostProvider =
    StateNotifierProvider<StepperPostNotifier, StepperPostState>((ref) {
  return StepperPostNotifier();
});

class StepperPostNotifier extends StateNotifier<StepperPostState> {
  StepperPostNotifier()
      : super(StepperPostState(
          titleController: TextEditingController(),
          descriptionController: TextEditingController(),
          categoryController: TextEditingController(),
          locationController: TextEditingController(),
          formKeyPostDetails: GlobalKey<FormState>(),
          formKeyPostLocation: GlobalKey<FormState>(), 
          hasImageSelected: false,
        ));

  void setTitle(String title) {
    state = state.copyWith(titleController: TextEditingController(text: title));
  }

  void setDescription(String description) {
    state = state.copyWith(
        descriptionController: TextEditingController(text: description));
  }

  void setCategory(String category) {
    state = state.copyWith(
        categoryController: TextEditingController(text: category));
  }

  void setLocation(String location) {
    state = state.copyWith(
        locationController: TextEditingController(text: location));
  }

  void setNotification(bool notification) {
    state = state.copyWith(hasNotification: notification);
  }

  void setPremium(bool premium) {
    state = state.copyWith(hasPremium: premium ? 1 : 0);
  }

  void setImage(File image) {
    state = state.copyWith(selectedImage: image);
  }

  void setHasImageSelected(bool hasImageSelected) {
    state = state.copyWith(hasImageSelected: hasImageSelected);
  }

  void clear() {
    state.titleController.clear();
    state.descriptionController.clear();
    state.categoryController.clear();
    state.locationController.clear();
    
    state = state.copyWith(selectedImage: null, hasImageSelected: false, hasNotification: false, hasPremium: 0);
  }

  Map<String, dynamic> getAll() {
    return {
      'title': state.titleController.text,
      'description': state.descriptionController.text,
      'category': state.categoryController.text,
      'location': state.locationController.text,
      'image': state.selectedImage,
      'notificationsEnabled': state.hasNotification,
      'hasPremium': state.hasPremium,
    };
  }
}
