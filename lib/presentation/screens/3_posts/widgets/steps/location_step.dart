import 'package:chambeape/config/utils/dropdown_items.dart';
import 'package:chambeape/presentation/providers/posts/steps/step_provider.dart';
import 'package:chambeape/presentation/screens/3_posts/widgets/stepper_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationStep extends ConsumerStatefulWidget {
  const LocationStep({
    super.key,
    required this.hasPost,
    required this.widget,
  });

  final bool hasPost;
  final StepperPost widget;

  @override
  createState() => _LocationStepState();
}

class _LocationStepState extends ConsumerState<LocationStep> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    final stepperPost = ref.watch(stepperPostProvider.notifier);
    final stepperPostState = ref.watch(stepperPostProvider);
    final text = Theme.of(context).textTheme;

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: stepperPostState.formKeyPostLocation,
      child: Column(
        children: [
          Text('Ubicación del trabajo', style: text.headlineSmall),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Departamento',
            ),
            value: dropdownValue,
            items: departaments.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
              stepperPost.setLocation(newValue!);
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, seleccione un departamento';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
