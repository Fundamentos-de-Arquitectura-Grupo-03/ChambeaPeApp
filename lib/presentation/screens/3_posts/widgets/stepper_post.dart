import 'package:chambeape/config/utils/login_user_data.dart';
import 'package:chambeape/domain/entities/posts_entity.dart';
import 'package:chambeape/infrastructure/models/login/login_response.dart';
import 'package:chambeape/presentation/providers/posts/post_provider.dart';
import 'package:chambeape/presentation/providers/posts/steps/step_provider.dart';
import 'package:chambeape/presentation/screens/3_posts/widgets/step_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chambeape/services/media/MediaService.dart';

class StepperPost extends ConsumerStatefulWidget {
  final Post? post;

  const StepperPost({super.key, this.post});

  @override
  createState() => _StepperPostState();
}

class _StepperPostState extends ConsumerState<StepperPost> {
  bool hasPost = false;
  int currStep = 0;
  int postId = 0;
  String postImageUri = '';

  LoginResponse user = LoginData().user;

  @override
  void initState() {
    super.initState();
    hasPost = widget.post != null;
    postId = widget.post?.id ?? 0;
    postImageUri = widget.post?.imgUrl ?? '';

    LoginData().loadSession().then((value) {
      setState(() {
        user = value;
      });
    });

    if (hasPost && widget.post != null) {
      Future.microtask(() {
        final stepperPostProv = ref.read(stepperPostProvider.notifier);
        stepperPostProv.setTitle(widget.post!.title);
        stepperPostProv.setDescription(widget.post!.description);
        stepperPostProv.setCategory(widget.post!.subtitle);
        stepperPostProv.setLocation('');
        stepperPostProv.setNotification(false);
        stepperPostProv.setPremium(false);
        stepperPostProv.setHasImageSelected(false);
      });
    } else {
      Future.microtask(() {
        final stepperPostProv = ref.read(stepperPostProvider.notifier);
        stepperPostProv.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepperPostState = ref.watch(stepperPostProvider);
    final stepperPostProv = ref.watch(stepperPostProvider.notifier);

    StepState switchStepState(int step) {
      if (currStep > step) {
        return StepState.complete;
      } else if (currStep < step) {
        return StepState.disabled;
      } else {
        return StepState.editing;
      }
    }

    final buttonStyle = ButtonStyle(
      minimumSize: WidgetStateProperty.resolveWith(
        (states) => const Size(110, 40),
      ),
    );

    const totalSteps = 4;
    return Scaffold(
      appBar: AppBar(
        title: Text(hasPost ? 'Editar Publicación' : 'Crear Publicación'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: currStep,
              onStepContinue: () async {
                // Validar el formulario antes de pasar al siguiente paso
                final formDetails =
                    stepperPostState.formKeyPostDetails.currentState;
                final formLocation =
                    stepperPostState.formKeyPostLocation.currentState;

                if (currStep == 0 &&
                    formDetails != null &&
                    formDetails.validate() &&
                    stepperPostState.hasImageSelected) {
                  setState(() {
                    currStep += 1;
                  });
                } else if (currStep == 1 &&
                    formLocation != null &&
                    formLocation.validate()) {
                  setState(() {
                    currStep += 1;
                  });
                } else if (currStep == 2) {
                  setState(() {
                    currStep += 1;
                  });
                }
              },
              onStepCancel: () {
                if (currStep > 0) {
                  setState(() {
                    currStep -= 1;
                  });
                }
              },
              steps: [
                Step(
                  title: const SizedBox.shrink(),
                  content: DetailsStep(hasPost: hasPost, widget: widget),
                  isActive: currStep >= 0,
                  state: switchStepState(0),
                ),
                Step(
                  title: const SizedBox.shrink(),
                  content: LocationStep(hasPost: hasPost, widget: widget),
                  isActive: currStep >= 1,
                  state: switchStepState(1),
                ),
                Step(
                  title: const SizedBox.shrink(),
                  content: const SettingStep(),
                  isActive: currStep >= 2,
                  state: switchStepState(2),
                ),
                Step(
                  title: const SizedBox.shrink(),
                  content: const ConfirmStep(),
                  isActive: currStep >= 3,
                  state: switchStepState(3),
                ),
              ],
              controlsBuilder: (context, details) {
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (currStep > 0)
                  FilledButton(
                    style: buttonStyle,
                    onPressed: () {
                      setState(() {
                        currStep -= 1;
                      });
                    },
                    child: const Text('Volver'),
                  ),
                if (currStep < totalSteps - 1)
                  FilledButton(
                    style: buttonStyle,
                    onPressed: () async {
                      final formDetails =
                          stepperPostState.formKeyPostDetails.currentState;
                      final formLocation =
                          stepperPostState.formKeyPostLocation.currentState;

                      if (currStep == 0 &&
                          formDetails != null &&
                          formDetails.validate() &&
                          stepperPostState.hasImageSelected) {
                        setState(() {
                          currStep += 1;
                        });
                      } else if (currStep == 1 &&
                          formLocation != null &&
                          formLocation.validate()) {
                        setState(() {
                          currStep += 1;
                        });
                      } else if (currStep == 2) {
                        setState(() {
                          currStep += 1;
                        });
                      }
                    },
                    child: const Text('Siguiente'),
                  ),
                if (currStep == totalSteps - 1)
                  FilledButton(
                    style: buttonStyle,
                    onPressed: () async {
                      // Guardar el post
                      print('Guardando post...');
                      final data = stepperPostProv.getAll();

                      print(data['image']);
                      print(postImageUri); // Para el update de la imagen

                      Uri imageUri = await MediaService().saveFileToGoogleCloud(
                          stepperPostState.selectedImage!);

                      Post dataPost = Post(
                        id: postId,
                        title: data['title'],
                        description: data['description'],
                        subtitle: data['category'],
                        imgUrl: imageUri.toString(),
                        employerId: user.id,
                      );

                      print('id: ${dataPost.id}');
                      print('title: ${dataPost.title}');
                      print('description: ${dataPost.description}');
                      print('subtitle: ${dataPost.subtitle}');
                      print('imgUrl: ${dataPost.imgUrl}');

                      if (hasPost) {
                        await ref
                            .read(postsProvider.notifier)
                            .updatePost(dataPost, user.userRole);
                      } else {
                        await ref
                            .read(postsProvider.notifier)
                            .createPost(dataPost, user.userRole);
                      }

                      Navigator.of(context).pop();
                    },
                    child: const Text('Guardar'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
