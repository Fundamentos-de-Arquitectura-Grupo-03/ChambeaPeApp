import 'package:chambeape/presentation/providers/posts/steps/step_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmStep extends ConsumerStatefulWidget {
  const ConfirmStep({super.key});

  @override
  createState() => _ConfirmStepState();
}

class _ConfirmStepState extends ConsumerState<ConfirmStep> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final stepperPostState = ref.watch(stepperPostProvider);
    final textStyle = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Confirmación', style: textStyle.headlineSmall),
          const SizedBox(height: 16),
          _InfoLabel(
              textStyle: textStyle,
              data: stepperPostState.titleController.text,
              title: 'Título'),
          _InfoLabel(
              textStyle: textStyle,
              data: stepperPostState.descriptionController.text,
              title: 'Descripción'),
          _InfoLabel(
              textStyle: textStyle,
              data: stepperPostState.categoryController.text,
              title: 'Categoría'),
          _InfoLabel(
              textStyle: textStyle,
              data: stepperPostState.locationController.text,
              title: 'Ubicación'),
          _InfoLabel(
              textStyle: textStyle,
              data: stepperPostState.hasNotification ? 'Sí' : 'No',
              title: 'Notificación'),
          _InfoLabel(
              textStyle: textStyle,
              data: stepperPostState.hasPremium == 1 ? 'Sí' : 'No',
              title: 'Premium'),
        ],
      ),
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final String title;
  final String data;
  final TextTheme textStyle;

  const _InfoLabel({
    required this.textStyle,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyle.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            data,
            style: textStyle.bodyMedium,
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}
