import 'package:chambeape/config/utils/login_user_data.dart';
import 'package:chambeape/infrastructure/models/login/login_response.dart';
import 'package:chambeape/presentation/providers/posts/post_provider.dart';
import 'package:chambeape/presentation/providers/posts/steps/step_provider.dart';
import 'package:chambeape/presentation/shared/widgets/premium_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingStep extends ConsumerStatefulWidget {
  const SettingStep({
    super.key,
  });

  @override
  createState() => _SetttingStepState();
}

class _SetttingStepState extends ConsumerState<SettingStep> {
  late LoginResponse user;
  bool hasPremium = false;

  @override
  void initState() {
    super.initState();
    ref.read(postsProvider.notifier).getPosts();
    LoginData().loadSession().then((value) {
      setState(() {
        user = value;
        hasPremium = user.hasPremium == 0 ? false : true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final stepperPostProv = ref.watch(stepperPostProvider.notifier);
    final stepperPostState = ref.watch(stepperPostProvider);
    final text = Theme.of(context).textTheme;

    bool resPremium = stepperPostState.hasPremium == 0 ? false : true;

    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Configuración', style: text.headlineSmall),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text('Destacar', style: text.headlineSmall),
            subtitle: Text('Función premium para destacar la publicación', style: text.bodySmall),
            value: resPremium,
            onChanged: (value) {
              if (!hasPremium) {
                showDialog(
                  context: context,
                  builder: (context) => const PremiumDialog(),
                );
              } else {
                stepperPostProv.setPremium(value);
                setState(() {});
              }
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text('Notificaciones', style: text.headlineSmall),
            subtitle: Text('Recibir notificaciones de la publicación', style: text.bodySmall),
            value: stepperPostState.hasNotification,
            onChanged: (notification) {
              stepperPostProv.setNotification(notification);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
